//
// Verilog Module my_projectsasas_lib.matmul_tb
//
// Created:
//          by - Eugene.UNKNOWN (DESKTOP-BCGV2R3)
//          at - 11:36:48 23-Feb-24
//
// using Mentor Graphics HDL Designer(TM) 2021.1 Built on 14 Jan 2021 at 15:11:42
//

`resetall
`timescale 1ns/10ps
module matmul_tb #(parameter BUS_WIDTH = 64, parameter DATA_WIDTH = 16, parameter ADDR_WIDTH = 16 ,parameter SP_NTARGETS = 4);

matmul_intf #( 
        .BUS_WIDTH(BUS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .SP_NTARGETS(SP_NTARGETS)) 
        tb();
matmul_stimulus #( 
        .BUS_WIDTH(BUS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .SP_NTARGETS(SP_NTARGETS))
        gen(.stim_bus(tb));
matmul_coverage #( 
        .BUS_WIDTH(BUS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .SP_NTARGETS(SP_NTARGETS))
        cov(.cov_bus(tb));
matmul_checker #( 
        .BUS_WIDTH(BUS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .SP_NTARGETS(SP_NTARGETS))
        check(.check_bus(tb));
matmul_golden #( 
        .BUS_WIDTH(BUS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .SP_NTARGETS(SP_NTARGETS))
        gold(.gold_bus(tb));
matmul #( 
        .BUS_WIDTH(BUS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .SP_NTARGETS(SP_NTARGETS))
        dut(
.clk_i    (tb.clk_i),
.rst_ni   (tb.rst_ni),
.psel_i   (tb.psel_i),
.penable_i(tb.penable_i),
.pwrite_i (tb.pwrite_i),
.pstrb_i  (tb.pstrb_i),
.pwdata_i (tb.pwdata_i),
.paddr_i  (tb.paddr_i),
.pready_o (tb.pready_o),
.pslverr_o(tb.pslverr_o),
.prdata_o (tb.prdata_o),
.busy_o   (tb.busy_o));
endmodule
