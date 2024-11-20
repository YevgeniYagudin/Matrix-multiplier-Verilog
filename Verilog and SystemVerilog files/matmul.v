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
-- CONNECT ALL 3 MAIN PARTS, EACH ONE DISCRUBED IN HEADER & DOCS
--
--------------------------------------------------------------------
-- VHDL Dialect: VHDL '93
--
--------------------------------------------------------------------*/

`resetall
`timescale 1ns/10ps
`include "APB_slave.v"          //import APB
`include "MatrixRegisterFile.v"  //MatrixRegisterFile APB
`include "HALF_MUL.v"              //HALF_MUL APB
`include "flow_control.v"            //import flow_control
module matmul #(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 16 ,parameter SP_NTARGETS = 4 )(
   clk_i,rst_ni,psel_i,penable_i,pwrite_i,pstrb_i,pwdata_i,paddr_i,pready_o,pslverr_o,prdata_o,busy_o);
   localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH;
   localparam LOC_ADDR_WIDTH = 9; //add inside RF
   input wire clk_i;           // clock signal
   input wire rst_ni;           // reset signal
   input wire psel_i;           // indicates the cpu ment to use this device
   input wire penable_i;       //
   input wire pwrite_i;            // idicates the device wants to write
   input wire [MAX_DIM-1:0] pstrb_i;   // not yet sure what to do with it in this module
   input wire [BUS_WIDTH-1:0] pwdata_i;   // probably unnecessary for this control unit since it's better if it's connected directly maybe, not sure
   input wire [ADDR_WIDTH-1:0] paddr_i;
   //outputs
   output pready_o;               //   for now unused maybe emplement it later
   output pslverr_o;             // an out error signal for sending to the bus
   output [BUS_WIDTH-1:0] prdata_o; // controls if the red data is poured out
   output busy_o;                  // busy signal from the system
// int wires between RF and SPB
   wire [BUS_WIDTH-1:0] reddata; //intern wire
   wire dowrite;        //intern wire
   wire doread;       //intern wire
   wire [LOC_ADDR_WIDTH - 1:0] address; //intern wire
   wire [BUS_WIDTH-1:0] writedata; //intern wire
   wire [MAX_DIM-1:0] pstrb_to_rf;
   //wire busy_o;
   wire [MAX_DIM*BUS_WIDTH-1:0] a_row; // REG-->flow
   wire [MAX_DIM*BUS_WIDTH-1:0] b_col; // REG-->flow
   wire [MAX_DIM*BUS_WIDTH-1:0] a_rowc;//flow-->MUL
   wire [MAX_DIM*BUS_WIDTH-1:0] b_colc;//flow-->MUL
   wire [MAX_DIM*MAX_DIM*BUS_WIDTH-1:0] fin_r; // MUL-->REG
   wire [MAX_DIM*MAX_DIM-1:0] ouflow_o; //flag
   wire busy; //intern wire
   wire start_bit; //intern wire
   APB_slave #(.BUS_WIDTH(BUS_WIDTH),.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .SP_NTARGETS(SP_NTARGETS))
    U_APB_SLAVE( //MASTER TO SLAVE
   //connection MASTER<->APB
   .clk_i(clk_i),
   .rst_ni(rst_ni),
   .psel_i(psel_i),
   .penable_i(penable_i),
   .pwrite_i(pwrite_i),
   .pstrb_i(pstrb_i),
   .pstrb_to_rf(pstrb_to_rf),
   .pwdata_i(pwdata_i),
   .paddr_i(paddr_i),
   .pready_o(pready_o),
   .pslverr_o(pslverr_o),
   .prdata_o(prdata_o),
   .busy_o(busy_o),
   //connection APB<->REG
   .reddata_i(reddata), //data to master
   .dowrite_o(dowrite), // enable to rf
   .locaddr_o(address), //addr inside RF
   .writedata_o(writedata), //data to RF
   .mulbusy_i(busy) //block master
   );
   MatrixRegisterFile #(.BUS_WIDTH(BUS_WIDTH),.DATA_WIDTH(DATA_WIDTH),.SP_NTARGETS(SP_NTARGETS), .ADDR_WIDTH(ADDR_WIDTH))
     U_matrix_reg_file ( //SLAVE TO RF
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .write_enable(dowrite), //enable
    .start_bit(start_bit), //start from control[0]
    .done_i(done_o),  //tell to slave
    .address(address), //from slave
    .pstrb_i(pstrb_to_rf), //from slave
    .data_in(writedata), //from slave
    .fin_r_o(fin_r), //from MUL
    .data_out(reddata), //to slave
    .ouflow_i(ouflow_o), //from MUL
    .a_row_o(a_row), //to MUL
    .b_col_o(b_col) //to MUL
);
flow_control #(.BUS_WIDTH(BUS_WIDTH),.DATA_WIDTH(DATA_WIDTH))
     U_flow_control( //REG-->flow-->MUL
    .a_row_i(a_row),  //from RF to flow
    .b_col_i(b_col),   //from RF to flow
    .clk_i(clk_i), .rst_ni(rst_ni), .start_bit(start_bit), //signals
    .a_row_o(a_rowc),  //from flow to MUL
    .b_col_o(b_colc)    //from flow to MUL
    );
HALF_MUL #(.BUS_WIDTH(BUS_WIDTH),.DATA_WIDTH(DATA_WIDTH))
     U_half_mul ( //RESULTS TO RF
    .a_row_i(a_rowc),  //from flow to MUL
    .b_col_i(b_colc),    //from flow to MUL
    .clk_i(clk_i), .rst_ni(rst_ni), //signals
    .start_bit(start_bit),.busy(busy), .done_o(done_o), //signals
    .ouflow_o(ouflow_o), //flags
    .fin_r_o(fin_r) //output to RF
);   
endmodule