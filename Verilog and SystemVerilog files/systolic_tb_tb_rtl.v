//
// Test Bench Module my_project_lib.SYSTOLIC_tb.SYSTOLIC_tester
//
// Created:
//          by - Eugene.UNKNOWN (DESKTOP-BCGV2R3)
//          at - 17:45:36 06-Feb-24
//
// Generated by Mentor Graphics' HDL Designer(TM) 2021.1 Built on 14 Jan 2021 at 15:11:42
//
`resetall
`timescale 1ns/10ps

module SYSTOLIC_tb;

// Local declarations
parameter BUS_WIDTH = 32;
parameter DATA_WIDTH = 8;
parameter CNTBITS = 4;
parameter N = 11;
localparam DIM = BUS_WIDTH/DATA_WIDTH;
// Internal signal declarations
wire [DIM * DATA_WIDTH - 1:0]      west_i;
wire [DIM * DATA_WIDTH - 1:0]      north_i;
wire                               clk_i;
wire                               rst_ni;
wire                               start_bit;
wire                               started;
wire                               done_o;
wire [DIM * DIM - 1:0]             ouflow_o;
wire [DIM * BUS_WIDTH * DIM - 1:0] fin_r_o;


SYSTOLIC #(32,8) U_0(
   .west_i    (west_i),
   .north_i   (north_i),
   .clk_i     (clk_i),
   .rst_ni     (rst_ni),
   .start_bit (start_bit),
   .started   (started),
   .done_o    (done_o),
   .ouflow_o  (ouflow_o),
   .fin_r_o   (fin_r_o)
);

SYSTOLIC_tester #(32,8) U_1(
   .west_i    (west_i),
   .north_i   (north_i),
   .clk_i     (clk_i),
   .rst_ni     (rst_ni),
   .start_bit (start_bit),
   .started   (started),
   .done_o    (done_o),
   .ouflow_o  (ouflow_o),
   .fin_r_o   (fin_r_o)
);

endmodule // SYSTOLIC_tb


