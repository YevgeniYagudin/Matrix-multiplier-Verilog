//
// Verilog interface my_projectsasas_lib.matmul_intf
//
// Created:
//          by - Eugene.UNKNOWN (DESKTOP-BCGV2R3)
//          at - 19:00:06 21-Feb-24
//
// using Mentor Graphics HDL Designer(TM) 2021.1 Built on 14 Jan 2021 at 15:11:42
//

`resetall
`timescale 1ns/10ps
interface matmul_intf#(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 16 ,parameter SP_NTARGETS = 4 )();

   localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH;
   localparam LOC_ADDR_WIDTH = 9; //add inside RF
   logic clk_i;           // clock signal
   logic rst_ni;           // reset signal
   logic psel_i;           // indicates the cpu ment to use this device
   logic penable_i;       //
   logic pwrite_i;            // idicates the device wants to write
   logic [MAX_DIM-1:0] pstrb_i;   // not yet sure what to do with it in this module
   logic [BUS_WIDTH-1:0] pwdata_i;   // probably unnecessary for this control unit since it's better if it's connected directly maybe, not sure
   logic [ADDR_WIDTH-1:0] paddr_i;
   logic pready_o;                 //   for now unused maybe emplement it later
   logic pslverr_o;                // an out error signal for sending to the bus
   logic [BUS_WIDTH-1:0] prdata_o; // controls if the red data is poured out
   logic busy_o;                   // busy signal from the system

  modport matmul_stimulus (output clk_i,rst_ni,psel_i,penable_i,pwrite_i,pstrb_i,pwdata_i,paddr_i,  pready_o,pslverr_o,prdata_o,busy_o);
  modport matmul_checker (input clk_i,rst_ni,psel_i,penable_i,pwrite_i,pstrb_i,pwdata_i,paddr_i,  pready_o,pslverr_o,prdata_o,busy_o);
  modport matmul_coverage (input clk_i,rst_ni,psel_i,penable_i,pwrite_i,pstrb_i,pwdata_i,paddr_i, pready_o,pslverr_o,prdata_o,busy_o);
  modport matmul_golden (input clk_i,rst_ni,prdata_o,busy_o);
  
endinterface
