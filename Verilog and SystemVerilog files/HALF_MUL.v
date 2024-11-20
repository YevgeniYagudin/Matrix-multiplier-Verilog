/*--------------------------------------------------------------------
-- COPYRIGHT (c) ABC, 2009
-- The copyright to the document herein is the property of ABC.
--
-- All rights reserved.
--------------------------------------------------------------------
--
-- Author: Yevg Yevgi
-- Created: 05-01-2009 13:24
--
--------------------------------------------------------------------
-- Description:
--
-- CONNECTS PUSHER TO SYSTOLIC.
-- PUSHER CONTROLS THE TIMING OF INPUTS CHUNKS(BYTES) TO SYSTOLIC
-- TO MAINTAIN PROPER TIMING FOR ALGORYTHM OF MULTIPLYING
--
--------------------------------------------------------------------
-- VHDL Dialect: VHDL '93
--
--------------------------------------------------------------------*/
`resetall
`timescale 1ns/10ps
`include "SYSTOLIC.v"
`include "Pusher.v"
module HALF_MUL #(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 8)(
          a_row_i,b_col_i,clk_i, rst_ni, start_bit, busy ,done_o,ouflow_o,fin_r_o);
   //input-output
   localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH;
   input [MAX_DIM*BUS_WIDTH-1:0] a_row_i; //input row
   input [MAX_DIM*BUS_WIDTH-1:0] b_col_i; //input col
   input clk_i; //clock in
   input rst_ni; //reset in
   input start_bit; //start
   output busy; //busy
   output done_o; //done
   output [MAX_DIM*MAX_DIM-1:0] ouflow_o; //overflow
   output [MAX_DIM*MAX_DIM*BUS_WIDTH-1:0] fin_r_o; //output result combined
   //wires
   wire [MAX_DIM*DATA_WIDTH-1:0] a_row; //input row
   wire [MAX_DIM*DATA_WIDTH-1:0] b_col; //input col
   SYSTOLIC #(.BUS_WIDTH(BUS_WIDTH),.DATA_WIDTH(DATA_WIDTH)) //pass params
    U_M ( //to  systoloic
    .west_i(a_row), //A rows goes from west
    .north_i(b_col),//B cols goes from north
    .clk_i(clk_i),.rst_ni(rst_ni),.start_bit(start_bit), //all control bits
    .started(busy),.done_o(done_o), .ouflow_o(ouflow_o), //all feedback bits
    .fin_r_o(fin_r_o) //the answer, flatten AB+C matrix
); //finish maping systolic 
   genvar i; //to generate exact pushers
   generate //pushers
    for (i = 0; i < MAX_DIM; i = i + 1) begin : gen_pusher
        Pusher #(.BUS_WIDTH(BUS_WIDTH),.DATA_WIDTH(DATA_WIDTH)) //for A matrix by rows
        U_Ni (.clk_i(clk_i),.rst_ni(rst_ni), //clk,rst as usual
        .data_i(b_col_i[MAX_DIM*BUS_WIDTH-i*BUS_WIDTH-1 : MAX_DIM*BUS_WIDTH-(i+1)*BUS_WIDTH]),
        .data_o(b_col[MAX_DIM*DATA_WIDTH-i*DATA_WIDTH-1 : MAX_DIM*DATA_WIDTH-(i+1)*DATA_WIDTH])
        ); //finish maping pusher for B matrix
        Pusher #(.BUS_WIDTH(BUS_WIDTH),.DATA_WIDTH(DATA_WIDTH)) //for B matrix by cols
        U_Wi (.clk_i(clk_i),.rst_ni(rst_ni), //clk,rst as usual
        .data_i(a_row_i[MAX_DIM*BUS_WIDTH-i*BUS_WIDTH-1 : MAX_DIM*BUS_WIDTH-(i+1)*BUS_WIDTH]),
        .data_o(a_row[MAX_DIM*DATA_WIDTH-i*DATA_WIDTH-1 : MAX_DIM*DATA_WIDTH-(i+1)*DATA_WIDTH])
        ); //finish maping pusher for A matrix
    end
   endgenerate //pushers
endmodule //HALF_MUL