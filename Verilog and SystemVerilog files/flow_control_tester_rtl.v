//
//THIS TEST SHOWS "BEEF_FFEC_12CC_ABAC_EFEF_5678_ABCD_1234"
// IS MASKED EVERY CYCLE AS WE NEED.
// EVERY CYCLE THE NEXT TOP BUS_WIDTH IS MASKED.
//          
//          
//
// 
//
`resetall
`timescale 1ns/10ps
module flow_control_tester (a_row_i,b_col_i,
                            clk_i,
                            rst_ni,
                            start_bit,
                            a_row_o,b_col_o
                           );

// Local declarations

parameter BUS_WIDTH = 32;
parameter DATA_WIDTH = 8;
parameter DIM = (BUS_WIDTH / DATA_WIDTH);


output a_row_i;
output b_col_i;
output clk_i;
output rst_ni;
output start_bit;
input  a_row_o;
input  b_col_o;

reg [(BUS_WIDTH / DATA_WIDTH) * BUS_WIDTH - 1:0] a_row_i;
reg [(BUS_WIDTH / DATA_WIDTH) * BUS_WIDTH - 1:0] b_col_i;
reg                                              clk_i;
reg                                              rst_ni;
reg                                              start_bit;
wire [(BUS_WIDTH / DATA_WIDTH) * BUS_WIDTH - 1:0] a_row_o;
wire [(BUS_WIDTH / DATA_WIDTH) * BUS_WIDTH - 1:0] b_col_o;

always #(5) clk_i <= ~clk_i;

initial begin
rst_ni <= 1;
clk_i <= 0;
start_bit <= 0; //256 got max leng case, if lower, only lower 128(or less) bits will be taken
a_row_i <= 256'hCACA_AFAF_12CC_ABAC_EFEF_5678_ABCD_1234_BEEF_FFEC_12CC_ABAC_EFEF_5678_ABCD_1234;
b_col_i <= 256'hCECE_FEFF_12CC_ABAC_EFEF_5678_ABCD_1234_BEEF_FFEC_12CC_ABAC_EFEF_5678_ABCD_1234;
#10
rst_ni <= 0;
#100
start_bit <= 1;
#10
start_bit <= 0;
end
endmodule // flow_control_tester


