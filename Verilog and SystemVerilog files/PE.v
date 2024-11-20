/*--------------------------------------------------------------------
-- COPYRIGHT (c) ABC, 2024
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
-- TAKES 2 inputs, mult them and accamulate them.
--
--------------------------------------------------------------------
-- VHDL Dialect: VHDL '93
--
--------------------------------------------------------------------*/
`resetall
`timescale 1ns/10ps

module PE #(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 8)
   (north_i, west_i, clk_i, rst_ni, clr, south_o, east_o, res_o, ouflow_o);
   
   input signed [DATA_WIDTH-1:0] north_i;   // element came from north
   input signed [DATA_WIDTH-1:0] west_i;    // element came from west
   input clk_i;                      // clock
   input rst_ni;                     // reset
   input clr;                        // clr after done row*col
   output reg signed [DATA_WIDTH-1:0] south_o;  // element goes to south
   output reg signed [DATA_WIDTH-1:0] east_o;   // element goes to east
   output reg signed [BUS_WIDTH-1:0] res_o;     // result, without extra bit for overflow/underflow
   output reg ouflow_o; // Overflow or underflow flag
   
   wire [2*DATA_WIDTH-1:0] multi_r;      // temp result of multiplication
   wire [BUS_WIDTH:0] sum_r;             // temp result of addition, with extra bit for overflow detection
   wire rst_intr;                        // reset or done last row*col multiplication
   
   // Detect overflow/underflow after addition
   wire overflow, underflow;
   assign overflow = (res_o[BUS_WIDTH-1] == 0 && multi_r[2*DATA_WIDTH-1] == 0 && sum_r[BUS_WIDTH-1] == 1) ? 1'b1 : 1'b0;
   assign underflow = (res_o[BUS_WIDTH-1] == 1 && multi_r[2*DATA_WIDTH-1] == 1 && sum_r[BUS_WIDTH-1] == 0) ? 1'b1 : 1'b0;
   
   always @(posedge clk_i) begin :work_proc
      if (rst_intr) begin
         res_o <= 0; //reset
         east_o <= 0; //reset
         south_o <= 0; //reset
         ouflow_o <= 0; //warning not reseted??? why 
      end else begin
         res_o <= sum_r[BUS_WIDTH-1:0]; // Update result without the overflow bit
         if (overflow | underflow) ouflow_o <= 1; // Set overflow/underflow flag
         east_o <= west_i; // Propagate
         south_o <= north_i; // Propagate
      end
   end //work_proc
   
   // Calculation of sum, with consideration for overflow/underflow
   assign sum_r = res_o + { {BUS_WIDTH-2*DATA_WIDTH{multi_r[2*DATA_WIDTH-1]}}, multi_r };
   assign multi_r = north_i * west_i; // Multiplication result
   assign rst_intr = rst_ni || clr; // Reset or done last row*col multiplication
endmodule
