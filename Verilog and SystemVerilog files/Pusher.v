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
-- Assistant module, upon recieving BUS_WIDTH data, split it into
-- DIM chunks, single chunk DATA_WDITH every clock cycle.
--
--------------------------------------------------------------------
-- VHDL Dialect: VHDL '93
--
--------------------------------------------------------------------*/
`resetall
`timescale 1ns/10ps
module Pusher #(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 8)(
   clk_i,rst_ni,data_i,data_o);
   localparam BUSmDATA = BUS_WIDTH - DATA_WIDTH; //to make less then 72ch
   input wire clk_i;  //clock input
   input wire rst_ni;   //reset input
   input wire [BUS_WIDTH-1:0] data_i;  //row/col input
   output reg [DATA_WIDTH-1:0] data_o; //single element output
   reg [BUS_WIDTH-DATA_WIDTH-1:0] shift_reg; //[23:0] for 32-8
   reg started; //flag
   always @(posedge clk_i ) begin :push_byte_proc
      if (rst_ni) begin
         shift_reg <= 0; //reset shifter
         data_o <= 0;  //reset data output
         started <= 0;  //reset flag
      end else if (!started && data_i != 0) begin
         shift_reg <= data_i[BUS_WIDTH-DATA_WIDTH-1:0]; //[23:0]
         data_o <= data_i[BUS_WIDTH-1:BUS_WIDTH-DATA_WIDTH]; //[31:24]
         started <= 1; //flag up
      end else if (started) begin
         data_o <= shift_reg[BUSmDATA-1:BUSmDATA-DATA_WIDTH]; 
         //[23:16] for 32-8
         shift_reg <= shift_reg << DATA_WIDTH; //8 for 32-8
         if (shift_reg == 0) begin
            started <= 0;  //flag down
         end
      end
   end //push_byte_proc
endmodule //pusher

