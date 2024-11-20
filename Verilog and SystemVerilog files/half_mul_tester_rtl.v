//IN THIS TESTER WE CALC A*At , WHERE
// 
// WHERE A= | 1  2  3  4 |
//          | 5  6  7  8 |
//          | 9  A  B  C |   
//          | D  E  F 10 |  
// A*At=
// RESULT = |1E  46  6E  96 |
//          |46  AE 116 17E |
//          |6E 116 1BE 266 |
//          |96 17E 266 34E |
//
// for DIM=2=> A=|1  2|
//               |5  6|
//
// A*At=
// RESULT = | 5  17|
//          |17  3D|
`resetall
`timescale 1ns/10ps
module HALF_MUL_tester (a_row_i,
                        b_col_i,
                        clk_i,
                        rst_ni,
                        start_bit,
                        busy,
                        done_o,
                        ouflow_o,
                        fin_r_o
                       );

// Local declarations

parameter BUS_WIDTH = 32;
parameter DATA_WIDTH = 8;
parameter DIM = BUS_WIDTH/DATA_WIDTH;

output a_row_i;
output b_col_i;
output clk_i;
output rst_ni;
output start_bit;
input  busy;
input  done_o;
input  ouflow_o;
input  fin_r_o;

reg [DIM * BUS_WIDTH - 1:0]                                   a_row_i;
reg [DIM * BUS_WIDTH - 1:0]                                   b_col_i;
reg                                                           clk_i;
reg                                                           rst_ni;
reg                                                           start_bit;
wire                                                           busy;
wire                                                           done_o;
wire [BUS_WIDTH * BUS_WIDTH / (DATA_WIDTH * DATA_WIDTH) - 1:0] ouflow_o;
wire [DIM * DIM * BUS_WIDTH - 1:0]                             fin_r_o;

always #(5) clk_i <= ~clk_i;

task put_in_A;
    input [DATA_WIDTH-1:0] a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15;
    begin
      if (DIM==4)
             a_row_i = ({a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15});
      if (DIM==3)
             a_row_i = ({a0, a2,  a4, a8,  a12,  a9, a10, a14, a15});
      if (DIM==2)
             a_row_i = ({a0 ,a1, a4, a5});
    end
endtask


task put_in_B;
    input [DATA_WIDTH-1:0] a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15;
    begin
      if (DIM==4)
             b_col_i = ({a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15});
      if (DIM==3)
             b_col_i = ({a0, a1,  a2, a4,  a5,  a6, a8, a9, a10});
      if (DIM==2)
             b_col_i = ({a0 ,a1, a4, a5});
    end
endtask

initial begin
rst_ni <= 1;
clk_i <= 0;
start_bit <= 0;
#10
rst_ni <= 0;
#10
start_bit <= 1;
put_in_A(1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
put_in_B(1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
#10
start_bit <= 0;
put_in_A(0, 0, 0, 0, 5, 6, 7, 8, 0, 0, 0, 0, 0, 0, 0, 0);
put_in_B(0, 0, 0, 0, 5, 6, 7, 8, 0, 0, 0, 0, 0, 0, 0, 0);
#10
put_in_A(0, 0, 0, 0, 0, 0, 0, 0, 9, 10, 11, 12, 0, 0, 0, 0);
put_in_B(0, 0, 0, 0, 0, 0, 0, 0, 9, 10, 11, 12, 0, 0, 0, 0);
#10
put_in_A(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 14, 15, 16);
put_in_B(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 14, 15, 16);
#10
put_in_A(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
put_in_B(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
end
endmodule // HALF_MUL_tester


