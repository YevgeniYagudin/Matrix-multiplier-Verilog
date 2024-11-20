//
// Test Bench Module my_project_lib.Pusher_tb.Pusher_tester
//
// Created:
//          by - Eugene.UNKNOWN (DESKTOP-BCGV2R3)
//          at - 17:10:55 01-Feb-24
//
// Generated by Mentor Graphics' HDL Designer(TM) 2021.1 Built on 14 Jan 2021 at 15:11:42
//
`resetall
`timescale 1ns/10ps

module Pusher_tb;

// Local declarations

parameter BUS_WIDTH = 32*2;
parameter DATA_WIDTH = 8*2;

// Internal signal declarations
wire        clk_i;
wire        rst_ni;
wire [BUS_WIDTH-1:0] data_i;
wire [DATA_WIDTH-1:0]  data_o;


Pusher #(BUS_WIDTH,DATA_WIDTH) 
U_0(
   .clk_i  (clk_i),
   .rst_ni  (rst_ni),
   .data_i (data_i),
   .data_o (data_o)
);

Pusher_tester #(BUS_WIDTH,DATA_WIDTH) 
U_1(
   .clk_i  (clk_i),
   .rst_ni  (rst_ni),
   .data_i (data_i),
   .data_o (data_o)
);

endmodule // Pusher_tb


