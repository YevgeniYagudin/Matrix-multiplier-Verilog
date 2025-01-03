//
// Test Bench Module my_project_lib.PE_tb.PE_tester
//
// Created:
//          by - Eugene.UNKNOWN (DESKTOP-BCGV2R3)
//          at - 16:15:37 06-Feb-24
//
// Generated by Mentor Graphics' HDL Designer(TM) 2021.1 Built on 14 Jan 2021 at 15:11:42
//
`resetall
`timescale 1ns/10ps

module PE_tb;

// Local declarations
parameter BUS_WIDTH = 32;
parameter DATA_WIDTH = 8;

// Internal signal declarations
wire [DATA_WIDTH - 1:0] north_i;
wire [DATA_WIDTH - 1:0] west_i;
wire                    clk_i;
wire                    rst_ni;
wire                    clr;
wire                    ouflow_o;
wire [DATA_WIDTH - 1:0] south_o;
wire [DATA_WIDTH - 1:0] east_o;
wire [BUS_WIDTH -1 :0]  res_o;


PE #(BUS_WIDTH,DATA_WIDTH) U_0(
   .north_i  (north_i),
   .west_i   (west_i),
   .clk_i    (clk_i),
   .rst_ni   (rst_ni),
   .clr      (clr),
   .ouflow_o (ouflow_o),
   .south_o  (south_o),
   .east_o   (east_o),
   .res_o    (res_o)
);

PE_tester #(BUS_WIDTH,DATA_WIDTH) U_1(
   .north_i  (north_i),
   .west_i   (west_i),
   .clk_i    (clk_i),
   .rst_ni   (rst_ni),
   .clr      (clr),
   .ouflow_o (ouflow_o),
   .south_o  (south_o),
   .east_o   (east_o),
   .res_o    (res_o)
);

endmodule // PE_tb


