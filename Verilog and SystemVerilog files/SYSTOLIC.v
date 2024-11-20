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
-- generate DIM*DIM net of connected PE's.
--
--------------------------------------------------------------------
-- VHDL Dialect: VHDL '93
--
--------------------------------------------------------------------*/
`resetall
`timescale 1ns/10ps
`include "PE.v"
module SYSTOLIC #(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 8)(
    west_i,  //inputs
    north_i, //inputs
    clk_i, rst_ni, start_bit, //clock reset start
    started, done_o, //working flags
    ouflow_o, //ou_flow flags
    fin_r_o //results
);  // parameters
    localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH; //res mat dimention
    //inputs outputs
    input [MAX_DIM*DATA_WIDTH-1:0] west_i;   //inputs
    input [MAX_DIM*DATA_WIDTH-1:0] north_i; //inputs
    input clk_i, rst_ni, start_bit; //clock reset start
    output reg started, done_o; //working flags
    output reg [MAX_DIM*MAX_DIM-1:0] ouflow_o; //ou_flow flags
    output reg [MAX_DIM*BUS_WIDTH*MAX_DIM-1:0] fin_r_o; //results
    //wires
    wire [DATA_WIDTH-1:0] north_int[MAX_DIM-1:0][MAX_DIM-1:0];//all N: wire->PE
    wire [DATA_WIDTH-1:0] west_int[MAX_DIM-1:0][MAX_DIM-1:0]; //all W: wire->PE
    wire [DATA_WIDTH-1:0] south_int[MAX_DIM-1:0][MAX_DIM-1:0];//all S: PE->wire
    wire [DATA_WIDTH-1:0] east_int[MAX_DIM-1:0][MAX_DIM-1:0]; //all E: PE->wire
    wire [BUS_WIDTH-1:0] res_int[MAX_DIM-1:0][MAX_DIM-1:0];//all result from PE
    wire ouflow_int [MAX_DIM-1:0][MAX_DIM-1:0];  //all ou_flow from PE
    wire [2*MAX_DIM*DATA_WIDTH-1:0] loose_ends; //unised bit
    genvar i, j, k; //for gen
    generate //start gen loop
        for (i = 0; i < MAX_DIM; i = i + 1) begin : rows //run by row
            for (j = 0; j < MAX_DIM; j = j + 1) begin : cols //run by cols
                PE #(.BUS_WIDTH(BUS_WIDTH),.DATA_WIDTH(DATA_WIDTH))
                pe_inst(
                    .north_i(i == 0 ? north_i[((MAX_DIM-1-j)*DATA_WIDTH)+DATA_WIDTH-1 : (MAX_DIM-1-j)*DATA_WIDTH] : south_int[i-1][j]),
                    .west_i(j == 0 ? west_i[((MAX_DIM-1-i)*DATA_WIDTH)+DATA_WIDTH-1 : (MAX_DIM-1-i)*DATA_WIDTH] : east_int[i][j-1]),
                    .clk_i(clk_i), //clock
                    .rst_ni(rst_ni), //rest
                    .clr(done_o), //reset accumulator
                    .south_o(south_int[i][j]), //to south prop
                    .east_o(east_int[i][j]), //to east prop
                    .ouflow_o(ouflow_int[i][j]),
                    .res_o(res_int[i][j])); //results
            end //cols
        end //rows
    endgenerate
    generate //start loose ends assign loop
        for (i = 0; i < MAX_DIM; i = i + 1) begin
            assign loose_ends[i*DATA_WIDTH +: DATA_WIDTH] = south_int[MAX_DIM-1][i]; //group unused logic
            assign loose_ends[BUS_WIDTH+i*DATA_WIDTH +: DATA_WIDTH] = east_int[i][MAX_DIM-1]; //group unused logic
        end
    endgenerate
integer ii, jj;
always @(*) begin: mapresult_proc
    if (rst_ni) begin
      fin_r_o = 0; //reset output
      ouflow_o = 0; //reset output
    end else begin
    for (ii = 0; ii < MAX_DIM; ii = ii + 1) begin //for colls
        for (jj = 0; jj< MAX_DIM; jj= jj + 1) begin //and rows map the results with overlfow
            fin_r_o[(ii*MAX_DIM + jj)*BUS_WIDTH +: BUS_WIDTH] = res_int[MAX_DIM-1-ii][MAX_DIM-1-jj];
            ouflow_o[ii*MAX_DIM + jj] = ouflow_int[MAX_DIM-1-ii][MAX_DIM-1-jj];
        end
    end end
end //mapresult_proc
    parameter CNTBITS = 4;
    parameter N = 11;
    reg [CNTBITS-1:0] cnt_r;
    always @(posedge clk_i) begin :calc_busy_time_proc //count busy time
    if (rst_ni) begin //output zero at reset
        cnt_r <= 0; //reset counter
        done_o <= 0; //reset flag
        started <= 0; //reset flag
    end else begin
        if (start_bit && !started) begin
            started <= 1; //if got startbit then pull flag
            done_o <= 0; //keep done=0
            cnt_r <= N; // must be 11 for 4x4 mat. because A[4,4] 
            //need to move 10 times (see skech) + 1 cycle for prop
        end else if (started) begin //count
            if (cnt_r > 0) begin
                cnt_r <= cnt_r - 1; //reduce count
                done_o <= 0; //keep done=0
            end else begin
                done_o <= 1; //pull done=1
                cnt_r <= 0;  //reset counter
                started <= 0; //lower flag
            end
        end else begin
            done_o <= 0;
        end
    end //calc_busy_time_proc
end
endmodule