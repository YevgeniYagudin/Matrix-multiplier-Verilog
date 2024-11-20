//
// Verilog Module lab1_lior_yevgeni_lib.inout_handler_tb
//
// Created:
//          by - liorpen.UNKNOWN (SHOHAM)
//          at - 15:01:06 01/24/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module APB_slave_tester (clk_i,rst_ni,psel_i,penable_i,pwrite_i,paddr_i,reddata_i,mulbusy_i,dowrite_o,doread_o,prdata_o,pslverr_o,busy_o,pwdata_i,pready_o,locaddr_o,writedata_o);

parameter DATA_WIDTH = 8;
parameter BUS_WIDTH = 32;
parameter ADDR_WIDTH = 16;
parameter SP_NTAGETS = 4;
parameter DIM = BUS_WIDTH/DATA_WIDTH;
parameter LOC_ADDR_WIDTH = 6;  

localparam CLK_NS = 10;
// ### Please start your Verilog code here ### 

output clk_i;
output reg rst_ni;
output reg psel_i;
output reg penable_i;
output reg pwrite_i;

output reg [BUS_WIDTH-1:0] pwdata_i;        // newly added
output reg [ADDR_WIDTH-1:0] paddr_i;

output reg [BUS_WIDTH-1:0] reddata_i;      // a signal with the data we want or don't want to read
output reg mulbusy_i; 

input pready_o;                  // newly added
input pslverr_o;
input [BUS_WIDTH-1:0] prdata_o; // controls if the red data is poured out
input busy_o;

input dowrite_o; //basicly a write enable for the register file  //  for some reson not letting this be a wire

input doread_o; //somekind of read enable   /// for some reason not letting this be a wire

input [LOC_ADDR_WIDTH - 1:0] locaddr_o;    // newly added
input [BUS_WIDTH-1:0] writedata_o;         // newly added

reg clk_i =1'b0;

always #(CLK_NS/2) clk_i<= ~clk_i;

initial begin: INOUT_TESTER
do_reset(2);
#100
psel_i <= 1; penable_i <= 1; pwdata_i <= 15; paddr_i <= 4; pwrite_i <= 1;
#10
psel_i <= 1; penable_i <= 1; pwdata_i <= 7; paddr_i <= 5; pwrite_i <= 0;
#10
psel_i <= 1; penable_i <= 1; pwdata_i <= 31; paddr_i <= 6; pwrite_i <= 1;
end  

task do_reset(input integer n);
  begin
    rst_ni = 1'b1;
    psel_i = 1'b0;
    penable_i = 1'b0;
    pwrite_i = 1'b0;
    mulbusy_i = 1'b0;
    paddr_i = {ADDR_WIDTH{1'b0}};
    reddata_i = {BUS_WIDTH{1'b0}};
    pwdata_i = {BUS_WIDTH{1'b0}};
    repeat(n) @(posedge clk_i);
    rst_ni = 1'b0;
  end
  endtask

task do_write(input integer n);
  begin
    psel_i = 1'b1;
    penable_i = 1'b1;
    pwrite_i = 1'b1;
    paddr_i = {ADDR_WIDTH{1'b0}};
    pwdata_i[7:0] = 8'b1010_0101;
    repeat(n) @(posedge clk_i);
    penable_i = 1'b1;
    repeat(n) @(posedge clk_i);
    psel_i = 1'b0;
    penable_i = 1'b0;
    pwdata_i = {BUS_WIDTH{1'b0}};
    pwrite_i = 1'b0;
    //mulbusy_i = 1'b0;
    paddr_i = {ADDR_WIDTH{1'b1}}; 
    
  end
endtask

task do_read(input integer n);
  begin
    psel_i = 1'b1;
    penable_i = 1'b1;
    pwrite_i = 1'b0;
    paddr_i = {ADDR_WIDTH{1'b0}};
    reddata_i[5:0] = 5'b101001;
    repeat(n) @(posedge clk_i);
    penable_i = 1'b1;
    repeat(n) @(posedge clk_i);
    psel_i = 1'b0;
    penable_i = 1'b0;
    pwrite_i = 1'b0;
    reddata_i[5:0] = 5'b000000;
    //mulbusy_i = 1'b0;
    paddr_i = {ADDR_WIDTH{1'b1}}; 
  end
endtask
    
task busy_write(input integer n);
  begin
    psel_i = 1'b1;
    penable_i = 1'b1;
    mulbusy_i = 1'b1;
    pwrite_i = 1'b1;
    paddr_i = {ADDR_WIDTH{1'b0}};
    pwdata_i[7:0] = 8'b0101_1010;
    repeat(n) @(posedge clk_i);
    penable_i = 1'b1;
    repeat(n) @(posedge clk_i);
    psel_i = 1'b0;
    penable_i = 1'b0;
    pwrite_i = 1'b0;
    pwdata_i = {BUS_WIDTH{1'b0}};
    paddr_i = {ADDR_WIDTH{1'b1}}; 
    mulbusy_i = 1'b0;
    
  end
endtask 
   
   task busy_read(input integer n);
  begin
    psel_i = 1'b1;
    penable_i = 1'b1;
    mulbusy_i = 1'b1;
    pwrite_i = 1'b0;
    paddr_i = {ADDR_WIDTH{1'b0}};
    reddata_i[5:0] = 5'b101111;
    repeat(n) @(posedge clk_i);
    penable_i = 1'b1;
    repeat(n) @(posedge clk_i);
    psel_i = 1'b0;
    penable_i = 1'b0;
    pwrite_i = 1'b0;
    reddata_i[5:0] = 5'b000000;
    paddr_i = {ADDR_WIDTH{1'b1}}; 
    mulbusy_i = 1'b0;
    
  end
endtask
   
   
    
 
 
    
    
    
endmodule
