//
// THIS TEST DEMOSTRATS SCALAR MULT OF 2 PAIRS OF VECRORS.
// THE FIRST CALC IS:
// (1,3,5,7)*(2,4,6,8) = 100
// AFTER THAT WE CLEAR THE ACCUMULATOR AND
// THE SECND CALC IS:
// (11,33,55,77)*(22,44,66,88) = 12100
//
`resetall
`timescale 1ns/10ps
module PE_tester (north_i,
                  west_i,
                  clk_i,
                  rst_ni,
                  clr,
                  south_o,
                  east_o,
                  res_o,
                  ouflow_o
                 );

// Local declarations

parameter BUS_WIDTH = 32;
parameter DATA_WIDTH = 8;


output north_i;
output west_i;
output clk_i;
output rst_ni;
output clr;

input  south_o;
input  east_o;
input  res_o;
input  ouflow_o;

reg [DATA_WIDTH - 1:0] north_i;
reg [DATA_WIDTH - 1:0] west_i;
reg                    clk_i;
reg                    rst_ni;
reg                    clr;
wire [DATA_WIDTH - 1:0] south_o;
wire [DATA_WIDTH - 1:0] east_o;
wire [BUS_WIDTH -1 :0]  res_o;
wire                  ouflow_o;

always #(5) clk_i <= ~clk_i;

initial begin
rst_ni <= 1;
clk_i <= 0;
clr <= 0;
north_i <= 0;
west_i <= 0;
#10
rst_ni<= 0;
#10
north_i <= -1;
west_i <= 2;
#10
north_i <= -3;
west_i <= 4;
#10
north_i <= -5;
west_i <= 6;
#10
north_i <= -7;
west_i <= 8;
#10
clr<=1;
#10
clr<=0;
north_i <= 11;
west_i <= 22;
#10
north_i <= 33;
west_i <= 44;
#10
north_i <= 55;
west_i <= 66;
#10
north_i <= 77;
west_i <= 88;
#10
clr<=1;
#10
clr<=0;
north_i <= 0;
west_i <= 0;
end
endmodule // PE_tester


