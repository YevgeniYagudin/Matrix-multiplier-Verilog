//
// Verilog Module my_projectsasas_lib.matmul_stimulus
//
// Created:
//          by - Eugene.UNKNOWN (DESKTOP-BCGV2R3)
//          at - 11:33:30 23-Feb-24
//
// using Mentor Graphics HDL Designer(TM) 2021.1 Built on 14 Jan 2021 at 15:11:42
//
`resetall
`timescale 1ns/10ps
module matmul_stimulus #(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 16 ,parameter SP_NTARGETS = 1 )
(matmul_intf.matmul_stimulus stim_bus);
localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH;
integer i,j,k,t=0;
longint A[0:MAX_DIM-1][0:MAX_DIM-1];
longint B[0:MAX_DIM-1][0:MAX_DIM-1];
always #5 stim_bus.clk_i = ~stim_bus.clk_i;
initial begin
    forever begin //option
    if (t == 0) reset_all;
    if (t != 0) #20;
    read_matrices(t+1); //t is the number of line in TXT
    //print_matrices;
    #50;                      //5 rest cycle
    @(posedge stim_bus.clk_i);
    stim_bus.psel_i <=1; stim_bus.penable_i <= 1; stim_bus.pwrite_i <= 1;
    for (i = 0; i < 4; i++) begin
      #10
      send_data(A[i][0], A[i][1], A[i][2], A[i][3]);
      to_address(4, i, 0);
      if (t%3 == 2) strobe(5+5*(i%2));
      #10;
    end
    for (i = 0; i < 4; i++) begin
      #10
      send_data(B[0][i], B[1][i], B[2][i], B[3][i]);
      to_address(8, i, 0);
      if (t%3 == 2) strobe(5+5*(i%2));
      #10;
    end
    #10 to_control((16'b00000000______00____11____11__0______1) ^ (2*(t%2)));
    //[15:14][13:12][11:10][9:8][7:6] [5:4] [3:2][1]    [0]
    //[~~~~~][--M--][--K--][-N-][~~~][srcC][tarC][+][Start]
    strobe(15);
    #20 to_control((16'b00000000______00____00____00__0______0) ^ (2*(t%2)));
    stim_bus.psel_i <=0; stim_bus.pwrite_i <= 0; stim_bus.penable_i <= 0;
    #150;
    stim_bus.psel_i <=1; stim_bus.pwrite_i <= 0; stim_bus.penable_i <= 1;
    #10;
    for (i = 0; i < MAX_DIM; i++) begin
        for (j = 0; j < MAX_DIM; j++) begin
            to_address(16, i, j); //read address 16=SP1 , 20=SP2 , 24=SP3 , 28=SP4
            #20;
    end end //end ij loop
    to_address(12, 0, 0);
    #20;
    stim_bus.psel_i <= 0; stim_bus.penable_i <= 0; stim_bus.pwrite_i <= 0;
    #25;
    t++;
    if (t==1000) begin //t = number CALCULATIONS TO RUN
      $display("====> Stopped after %d calculations <====",t);
      $stop;
    end end end
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

task read_matrices;
  integer file_descriptor;
  integer temp, i, j, char;
  input integer L;
  integer lines_skipped;

  file_descriptor = $fopen("C:\\Users\\Eugene\\PycharmProjects\\goldy\\matrix_A.txt", "r");
  if (file_descriptor == 0) begin
    $display("Error: Failed to open matrix_A.txt");
    $finish;
  end
  lines_skipped = 0;
  while (lines_skipped < L-1) begin
    char = $fgetc(file_descriptor);
    if (char == 10) begin
      lines_skipped = lines_skipped + 1;
    end
  end
  for (i = 0; i < MAX_DIM; i++) begin
    for (j = 0; j < MAX_DIM; j++) begin
      if (!$fscanf(file_descriptor, "%d,", temp)) begin
        $display("Error: Failed to read data for element %d, %d of matrix A", i, j);
        $fclose(file_descriptor);
        $finish;
      end
      A[i][j] = temp;
    end
  end
  $fclose(file_descriptor);
  file_descriptor = $fopen("C:\\Users\\Eugene\\PycharmProjects\\goldy\\matrix_B.txt", "r");
  if (file_descriptor == 0) begin
    $display("Error: Failed to open matrix_A.txt");
    $finish;
  end
  lines_skipped = 0;
  while (lines_skipped < L-1) begin
    char = $fgetc(file_descriptor);
    if (char == 10) begin 
      lines_skipped = lines_skipped + 1;
    end
  end
  for (i = 0; i < MAX_DIM; i++) begin
    for (j = 0; j < MAX_DIM; j++) begin
      if (!$fscanf(file_descriptor, "%d,", temp)) begin
        $display("Error: Failed to read data for element %d, %d of matrix B", i, j);
        $fclose(file_descriptor);
        $finish;
      end
      B[i][j] = temp;
    end
  end
  $fclose(file_descriptor);
endtask

task print_matrices;
  $display("Matrix A:");
  for (i = 0; i < MAX_DIM; i++) begin
    for (j = 0; j < MAX_DIM; j++) begin
      $write("%d ", A[i][j]);
    end
    $display("");
  end
  $display("\nMatrix B:");
  for (i = 0; i < MAX_DIM; i++) begin
    for (j = 0; j < MAX_DIM; j++) begin
      $write("%d ", B[i][j]);
    end
    $display("");
  end
endtask

task to_address;
    input [4:0] M;
    input [1:0] i;
    input [1:0] j;
    begin
        stim_bus.paddr_i <= {j,i,M}; 
    end
endtask

task to_control;
    input [15:0] a; 
    begin
        stim_bus.paddr_i <= 0;
        stim_bus.pwdata_i <= {a}; 
    end
endtask

task strobe;
    input [MAX_DIM-1:0] n; 
    begin
        stim_bus.pstrb_i <= n;
    end
endtask

task reset_all;
begin
    stim_bus.clk_i <= 0;
    stim_bus.pstrb_i <= {MAX_DIM{1'b1}};
    stim_bus.rst_ni <= 1;                       
    stim_bus.psel_i <= 0; stim_bus.penable_i <= 0; stim_bus.pwrite_i <= 0; 
    stim_bus.paddr_i <= 0; stim_bus.pwdata_i <= 0;             
    #20
    stim_bus.rst_ni <= 0;                          
end
endtask

task send_data;
    input [DATA_WIDTH-1:0] k, l, m, n; 
    begin
        stim_bus.pwdata_i <= {n, m, l, k}; 
    end
endtask

endmodule
