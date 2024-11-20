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
-- THIS MODULE IS APB SLAVE WHICH CONNECTS TO THE MASTER AND
-- AND CONTROLLED BY IT TO TRANSEFER DATA, READ AND WRITE.
--------------------------------------------------------------------
-- VHDL Dialect: VHDL '93
--
--------------------------------------------------------------------*/
`resetall  //      
`timescale 1ns/10ps  //
module APB_slave #(
    parameter BUS_WIDTH = 32, // bus width
    parameter DATA_WIDTH = 8, // data width
    parameter ADDR_WIDTH = 16, // address size
    parameter SP_NTARGETS = 4 // num of SP
)(
    // inputs
    input wire clk_i, // clock signal
    input wire rst_ni, // reset signal
    input wire psel_i, // select signal
    input wire penable_i, // enable signal
    input wire pwrite_i, // write/read signal
    input wire [BUS_WIDTH/DATA_WIDTH-1:0] pstrb_i, //  strobe
    input wire [BUS_WIDTH-1:0] pwdata_i, // data in
    input wire [ADDR_WIDTH-1:0] paddr_i, // address in 
    input wire [BUS_WIDTH-1:0] reddata_i, // data out RG->APB->MASTER
    input wire mulbusy_i, // matmul busy signal
    // outputs
    output reg pready_o, // ready signal
    output reg pslverr_o, // error signal
    output reg [BUS_WIDTH-1:0] prdata_o, // Data output
    output reg busy_o, // busy signal
    output reg [BUS_WIDTH/DATA_WIDTH-1:0] pstrb_to_rf, // strobe -> RF
    output reg dowrite_o, //  write enable -> RF
    output reg [ADDR_WIDTH-1:0] locaddr_o, // internal address
    output reg [BUS_WIDTH-1:0] writedata_o // data to write ->MUL
);
reg [1:0] current_state, next_state; // current and next state.
localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH; //based on bus/data width
localparam [1:0]  // states for FSM
    IDLE = 2'b00, // wait state
    SETUP = 2'b01, // prep state
    ACCESSt = 2'b10; // transfer state
always @(*) begin : FSM_state_proc // Decide next state based on current state and inputs
    case (current_state)
        IDLE: next_state = psel_i ? SETUP : IDLE; // If selected -> SETUP
        SETUP: next_state = ACCESSt; // SETUP goes to ACCESS
        ACCESSt: next_state = (!mulbusy_i && penable_i) ? (psel_i ? SETUP : IDLE) : ACCESSt; // change ST based on busy and enable
        default: next_state = IDLE; //not suposed to get here.
    endcase
end //FSM_state_proc

always @(posedge clk_i) begin : FSM_proc
    if (rst_ni) begin
        // If reset, go to initial state/values and put zeros
        current_state <= IDLE; //reset all
        pready_o <= 1'b0;
        pslverr_o <= 1'b0;
        prdata_o <= 0;
        //busy_o <= 1'b0;
        pstrb_to_rf <= {MAX_DIM{1'b1}};
        dowrite_o <= 1'b0;
        locaddr_o <= 0;
        writedata_o <= 0;
    end else begin
        current_state <= next_state; // Move to next state
        // Actions based on current state
        case (current_state)
            IDLE: begin
                pready_o <= 1'b1; // Ready in IDLE
            end
            SETUP: begin
                locaddr_o <= paddr_i; // take address
                writedata_o <= pwdata_i; // setup data
                pstrb_to_rf <= pstrb_i; // do strobe
                pready_o <= 1'b0; // not ready in SETUP
            end
            ACCESSt: begin
                if (penable_i) begin
                    if (pwrite_i) dowrite_o <= 1'b1; // Enable write
                    else prdata_o <= reddata_i; // Pass read data
                    pready_o <= !mulbusy_i; // Ready based on multiplier
                    pslverr_o <= mulbusy_i; // Error if busy
                end
            end
			default: $display("something wrong with APB state"); //not suposed to get here.
        endcase
    end
end //FSM_proc
always @(*) begin : busy_calc_proc // busy based on state and matmul
    busy_o = (current_state == ACCESSt) && (!pready_o || mulbusy_i); // busy cond
end //busy_calc_proc
endmodule
