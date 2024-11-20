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
-- THIS MODULE ACTS LIKE A BUFFER BETWEEN RF AND MULTIPLICATION
-- MODULE. AFTER GETTGING START_BIT HE WILL MASK THE TOP BUS_WIDTH
-- BITS TO MATCH THE TIMING FOR SYSTOLIC ALGORYTHM
--------------------------------------------------------------------
-- VHDL Dialect: VHDL '93
--
--------------------------------------------------------------------*/
`resetall
`timescale 1ns/10ps

module flow_control #(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 8)(
      a_row_i, //A input
      b_col_i,  //B input
      clk_i, //clock
      rst_ni, //reset
      start_bit, //start
      a_row_o, //A output
      b_col_o); //A output
   localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH; //max dim
   localparam STATES_bits = $clog2(MAX_DIM); //log2(dim)
   input [MAX_DIM*BUS_WIDTH-1:0] a_row_i;//inputs
   input [MAX_DIM*BUS_WIDTH-1:0] b_col_i;//inputs
   input clk_i, rst_ni, start_bit; //cock reset start
   output reg [MAX_DIM*BUS_WIDTH-1:0] a_row_o;//O
   output reg [MAX_DIM*BUS_WIDTH-1:0] b_col_o;//O
   reg [STATES_bits-1:0] current_state; //for states
   localparam ST0 = 0; // why error??? FSM states should not be of type Localparam.
   localparam ST1 = 1; // why error??? FSM states should not be of type Localparam.
   localparam ST2 = 2; // why error??? FSM states should not be of type Localparam.
   localparam ST3 = 3; // why error??? FSM states should not be of type Localparam.
   reg started; //flag
   always @(posedge clk_i) begin : init_proc // Reset and start logic
      if (rst_ni) //reset proc
      begin 
         current_state <= ST0; //reset state
         started <= 0; //reset flag
      end //rst
      else
      if (start_bit && !started) //if not already started
      begin //
         started <= 1; //flag
      end
      //if (current_state == MAX_DIM-1) begin //if all rows/col finished
      if (current_state == {STATES_bits{1'b1}}) begin //if all rows/col finished
         started <= 0; //break
      end
      {a_row_o , b_col_o} <= 0; //by default set output 0
      if (rst_ni) 
      begin
      end if (started) //if flag = 1
      begin
         case (current_state)
            ST0: begin //row0
               current_state <= ST1; // why error??? FSM states should not be of type Localparam.
               a_row_o[BUS_WIDTH*MAX_DIM-0*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-1*BUS_WIDTH] <= a_row_i[BUS_WIDTH*MAX_DIM-0*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-1*BUS_WIDTH]; //output 1st chunk
               b_col_o[BUS_WIDTH*MAX_DIM-0*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-1*BUS_WIDTH] <= b_col_i[BUS_WIDTH*MAX_DIM-0*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-1*BUS_WIDTH]; //output 1st chunk
            end
            ST1: begin //row1
               current_state <= ST2; // why error??? FSM states should not be of type Localparam.
               a_row_o[BUS_WIDTH*MAX_DIM-1*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-2*BUS_WIDTH] <= a_row_i[BUS_WIDTH*MAX_DIM-1*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-2*BUS_WIDTH]; //output next chunk
               b_col_o[BUS_WIDTH*MAX_DIM-1*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-2*BUS_WIDTH] <= b_col_i[BUS_WIDTH*MAX_DIM-1*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-2*BUS_WIDTH]; //output next chunk
            end
            ST2: begin //row2 if exist
               current_state <= ST3; // why error??? FSM states should not be of type Localparam.
               a_row_o[BUS_WIDTH*MAX_DIM-2*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-3*BUS_WIDTH] <= a_row_i[BUS_WIDTH*MAX_DIM-2*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-3*BUS_WIDTH]; //output next chunk
               b_col_o[BUS_WIDTH*MAX_DIM-2*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-3*BUS_WIDTH] <= b_col_i[BUS_WIDTH*MAX_DIM-2*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-3*BUS_WIDTH]; //output next chunk
            end
            ST3: begin //row3 if exist
               current_state <= ST0; // why error??? FSM states should not be of type Localparam.
               a_row_o[BUS_WIDTH*MAX_DIM-3*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-4*BUS_WIDTH] <= a_row_i[BUS_WIDTH*MAX_DIM-3*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-4*BUS_WIDTH]; //output next chunk
               b_col_o[BUS_WIDTH*MAX_DIM-3*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-4*BUS_WIDTH] <= b_col_i[BUS_WIDTH*MAX_DIM-3*BUS_WIDTH-1 : BUS_WIDTH*MAX_DIM-4*BUS_WIDTH]; //output next chunk
            end //will be break
            default: begin //default
               current_state <= ST0; //reset just in case
               started <= 0;  //reset just in case
               {a_row_o,b_col_o} <= 0; //dont output others
             end
            endcase
         end //end if(started) block
      end  // Reset and start logic
endmodule //flow_control