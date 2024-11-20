//
// Verilog Module lab1_lior_yevgeni_lib.inout_handler_tb
//
// Created:
//          by - liorpen.UNKNOWN (SHOHAM)
//          at - 15:00:30 01/24/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module APB_slave_tb ;
parameter DATA_WIDTH = 8;
parameter BUS_WIDTH = 32;
parameter ADDR_WIDTH = 16;
parameter SP_NTAGETS = 4;
parameter DIM = BUS_WIDTH/DATA_WIDTH;
parameter LOC_ADDR_WIDTH = 6;   // the loacl addres width' it's what is being transfered to theregister file 

wire clk_i;
wire  rst_ni;
wire  psel_i;
wire  penable_i;
wire  pwrite_i;


wire  [ADDR_WIDTH-1:0] paddr_i;

wire  [BUS_WIDTH-1:0] reddata_i;      // a signal with the data we want or don't want to read
wire  mulbusy_i; 


wire [BUS_WIDTH-1:0] pwdata_i;      // newly added
wire pslverr_o;
wire [BUS_WIDTH-1:0] prdata_o; // controls if the red data is poured out
wire busy_o;


wire pready_o;                  // newly added
wire dowrite_o; //basicly a write enable for the register file  //  for some reson not letting this be a wire

wire doread_o; //somekind of read enable   /// for some reason not letting this be a wire


wire [LOC_ADDR_WIDTH - 1:0] locaddr_o;    // newly added
wire [BUS_WIDTH-1:0] writedata_o;         // newly added
// ### Please start your Verilog code here ### 


APB_slave #(DATA_WIDTH,BUS_WIDTH,ADDR_WIDTH,SP_NTAGETS,MAX_DIM) U_1(
.clk_i (clk_i),
.rst_ni (rst_ni),
.psel_i (psel_i),
.penable_i (penable_i),
.pwrite_i (pwrite_i),
.paddr_i (paddr_i),
.reddata_i (reddata_i),
.mulbusy_i (mulbusy_i),
.pslverr_o (pslverr_o),
.prdata_o (prdata_o),
.busy_o (busy_o),
.dowrite_o (dowrite_o),
.pwdata_i (pwdata_i),
.pready_o (pready_o),
.locaddr_o (locaddr_o),
.writedata_o (writedata_o),
.doread_o (doread_o)
);

APB_slave_tester #(DATA_WIDTH,BUS_WIDTH,ADDR_WIDTH,SP_NTAGETS,MAX_DIM) U_2(
.clk_i (clk_i),
.rst_ni (rst_ni),
.psel_i (psel_i),
.penable_i (penable_i),
.pwrite_i (pwrite_i),
.paddr_i (paddr_i),
.reddata_i (reddata_i),
.mulbusy_i (mulbusy_i),
.pslverr_o (pslverr_o),
.prdata_o (prdata_o),
.busy_o (busy_o),
.dowrite_o (dowrite_o),
.pwdata_i (pwdata_i),
.pready_o (pready_o),
.locaddr_o (locaddr_o),
.writedata_o (writedata_o),
.doread_o (doread_o)
);

endmodule
