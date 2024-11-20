//
// THIS TEST DEMOSTRATS "0ABACDEF" vector
// Getting outputed by WORD size CHUNKS
// 0A -> BA -> CD -> EF, one by one every clock.
`resetall
`timescale 1ns/10ps
module Pusher_tester (clk_i,
                      rst_ni,
                      data_i,
                      data_o
                     );

// Local declarations


parameter BUS_WIDTH = 32;
parameter DATA_WIDTH = 8;

output clk_i;
output rst_ni;
output data_i;
input  data_o;

reg        clk_i;
reg        rst_ni;
reg [BUS_WIDTH-1:0] data_i;
wire [DATA_WIDTH-1:0]  data_o;

always #(5) clk_i <= ~clk_i;

initial begin
rst_ni <= 1;
clk_i <= 0;
#15 rst_ni <=0;
#55
data_i <= 32'hABACDEF;
#10;
data_i <= 32'h0;
end

endmodule // Pusher_tester


