//
// Verilog Module my_projectsasas_lib.matmul_golden
//
// Created:
//          by - Eugene.UNKNOWN (DESKTOP-BCGV2R3)
//          at - 11:39:29 25-Feb-24
//
// using Mentor Graphics HDL Designer(TM) 2021.1 Built on 14 Jan 2021 at 15:11:42
//

`resetall
`timescale 1ns/10ps
module matmul_golden #(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 16 ,parameter SP_NTARGETS = 4)
(matmul_intf.matmul_golden gold_bus);
localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH;
longint C[0:MAX_DIM-1][0:MAX_DIM-1];
integer F,i,j,t=0;
integer k=0,kk=0,kkk=0,fc=0,fcc=0; // hits out of total checks, for vals/flags
initial begin
    forever begin //option
    k=0; $display("\n=============>Starting iteration number:%d<===============",t+1);
    read_matrixC(t+1); //t is the number of line in TXT
    read_matrixF(t+1); //t is the number of line in TXT
    //print_matrixC; //if we want to... not the best idea if running many matrices
    t++;
    #430; 
    for (i = 0; i < MAX_DIM; i++) begin
      for (j = 0; j < MAX_DIM; j++) begin
        #20;kkk++;
        if ($signed(C[i][j]) == $signed(gold_bus.prdata_o)) begin
          $display("HIT!=> expected vs output: [%d:%d]" ,$signed(C[i][j]),$signed(gold_bus.prdata_o));
          k++;kk++;
        end else
          $display("ERR!=> expected vs output: [%d:%d]<=========MISS" ,$signed(C[i][j]),$signed(gold_bus.prdata_o));
        end
   end
   #20;
   if($signed(gold_bus.prdata_o) == F) begin 
     fc++;fcc++; $display("HIT!=> FLAGS: expected vs output: [%d:%d]" ,F,(gold_bus.prdata_o));
   end else begin
     fcc++;$display("ERR!=> FLAGS: expected vs output: [%d:%d]<=========MISS" ,F,(gold_bus.prdata_o));
   end
   $display("LAST   RUN HIT RATE: %.2f%%", 100.0 * $itor(k) / $itor(MAX_DIM * MAX_DIM));
   $display("WHOLE  SIM HIT RATE: %.2f%%", 100.0 * $itor(kk) / $itor(kkk));
   $display("TOTAL FLAG HIT RATE: %.2f%%", 100.0 * $itor(fc) / $itor(fcc));
   $display("TOTAL VALUES CHECKED: %d", $itor(kkk+fcc));
   #20;
   end //forever
end
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

task read_matrixC;
  integer file_descriptor;
  integer i, j, char;
  longint temp;
  input integer L;
  integer lines_skipped;

  file_descriptor = $fopen("C:\\Users\\Eugene\\PycharmProjects\\goldy\\matrix_C.txt", "r");
  if (file_descriptor == 0) begin
    $display("Error: Failed to open matrix_C.txt");
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
        $display("Error: Failed to read data for element %d, %d of matrix C", i, j);
        $fclose(file_descriptor);
        $finish;
      end
      C[i][j] = temp;
    end
  end
  $fclose(file_descriptor);
endtask;

task read_matrixF;
  integer file_descriptor;
  integer temp, i, j, char;
  input integer L;
  integer lines_skipped;
  F = 0;

  file_descriptor = $fopen("C:\\Users\\Eugene\\PycharmProjects\\goldy\\matrix_F.txt", "r");
  if (file_descriptor == 0) begin
    $display("Error: Failed to open matrix_F.txt");
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
        $display("Error: Failed to read data for element %d, %d of matrix C", i, j);
        $fclose(file_descriptor);
        $finish;
      end
      F = F + 2**(i*MAX_DIM+j)*temp;
    end
  end
  $fclose(file_descriptor);
endtask;

task print_matrixC;
  $display("Matrix C:");
  for (i = 0; i < MAX_DIM; i++) begin
    for (j = 0; j < MAX_DIM; j++) begin
      $write("%d ", C[i][j]);
    end
    $display("");
  end
endtask


endmodule
