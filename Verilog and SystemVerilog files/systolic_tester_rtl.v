//
//
// THIS TEST DEMONSTATES DATAFLOW AND PARTIAL MULTIPLICATION MADE,
// THIS MODULE IS ASSISTING MODULE AND ITS HARD TO SHOW         
// HIS FUNCTION FROM HIS POINT OF VIEW, SEE "HALF_MUL"
// TEST TO SEE THE MATRIX MULTIPLICATION BETTER
// 
//
`resetall
`timescale 1ns/10ps
module SYSTOLIC_tester (west_i,
                        north_i,
                        clk_i,
                        rst_ni,
                        start_bit,
                        started,
                        done_o,
                        ouflow_o,
                        fin_r_o
                       );

// Local declarations

parameter BUS_WIDTH = 32;
parameter DATA_WIDTH = 8;
parameter CNTBITS = 4;
parameter N = 11;
localparam DIM = BUS_WIDTH/DATA_WIDTH;

output west_i;
output north_i;
output clk_i;
output rst_ni;
output start_bit;
input  started;
input  done_o;
input  ouflow_o;
input  fin_r_o;

reg  [DIM * DATA_WIDTH - 1:0]      west_i;
reg  [DIM * DATA_WIDTH - 1:0]      north_i;
reg                                clk_i;
reg                                rst_ni;
reg                                start_bit;
wire                               started;
wire                               done_o;
wire [DIM * DIM - 1:0]             ouflow_o;
wire [DIM * BUS_WIDTH * DIM - 1:0] fin_r_o;

always #(5) clk_i <= ~clk_i;

initial begin
rst_ni <= 1;
clk_i <= 0;
start_bit <= 0;
west_i <= 0;
north_i<= 0;
#10
start_bit <= 1;
rst_ni <= 0;
#2
north_i<= {8'd0,8'd0,8'd0,8'd3};
west_i <= {8'd0,8'd0,8'd0,8'd4};
#10
north_i<= {8'd0,8'd0,8'd3,8'd0};
west_i <= {8'd0,8'd0,8'd2,8'd0};
#10
north_i<= {8'd0,8'd1,8'd0,8'd0};
west_i <= {8'd0,8'd7,8'd0,8'd0};
#10
north_i<= {8'd0,8'd0,8'd0,8'd0};
west_i <= {8'd0,8'd0,8'd0,8'd0};


end

endmodule // SYSTOLIC_tester


