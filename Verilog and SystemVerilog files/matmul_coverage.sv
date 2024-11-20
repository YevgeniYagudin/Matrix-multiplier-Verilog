//
// Verilog interface my_projectsasas_lib.matmul_coverage
//
// Created:
//          by - Eugene.UNKNOWN (DESKTOP-BCGV2R3)
//          at - 19:05:10 21-Feb-24
//
// using Mentor Graphics HDL Designer(TM) 2021.1 Built on 14 Jan 2021 at 15:11:42
//

`resetall
`timescale 1ns/10ps
module matmul_coverage #(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 16 ,parameter SP_NTARGETS = 4 )
(
  matmul_intf.matmul_coverage cov_bus
);
localparam BUS_Q = (2**BUS_WIDTH - 1)/4;
localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH;
covergroup regular_test @(posedge cov_bus.clk_i); 
  reset: coverpoint cov_bus.rst_ni{
  bins low = {0};
  bins high= {1}; 
}
  psel_i: coverpoint cov_bus.psel_i{
  bins low = {0};
  bins high= {1}; 
}
  penable_i: coverpoint cov_bus.penable_i{
  bins low = {0};
  bins high= {1}; 
}
  pwrite_i: coverpoint cov_bus.pwrite_i{
  bins low = {0};
  bins high= {1}; 
}
  pwdata: coverpoint cov_bus.pwdata_i{
  bins data_0_quart = {[0*BUS_Q:1*BUS_Q-1]};
  bins data_1_quart = {[1*BUS_Q:2*BUS_Q-1]};
}
  paddr: coverpoint cov_bus.paddr_i{
  bins addr_M = {[0: 2**5-1]};
  bins addr_i = {[0: 2**7-1]};
  bins addr_j = {[0: 2**9-1]};
}
endgroup 
covergroup extreme_test @(posedge cov_bus.clk_i); 
  reset: coverpoint cov_bus.rst_ni{
  bins low = {0};
  bins high= {1}; 
}
  psel_i: coverpoint cov_bus.psel_i{
  bins low = {0};
  bins high= {1}; 
}
  penable_i: coverpoint cov_bus.penable_i{
  bins low = {0};
  bins high= {1}; 
}
  pwrite_i: coverpoint cov_bus.pwrite_i{
  bins low = {0};
  bins high= {1}; 
}
  pstrb0_i: coverpoint cov_bus.pstrb_i[0]{
  bins low = {0};
  bins high= {1};
}
  pstrb1_i: coverpoint cov_bus.pstrb_i[1]{
  bins low = {0};
  bins high= {1};
}
  pstrb2_i: coverpoint cov_bus.pstrb_i[2]{
  bins low = {0};
  bins high= {1};
}
  pstrb3_i: coverpoint cov_bus.pstrb_i[3]{
  bins low = {0};
  bins high= {1};
}
  pwdata: coverpoint cov_bus.pwdata_i{
  bins data_0_quart = {[0*BUS_Q:1*BUS_Q-1]};
  bins data_1_quart = {[1*BUS_Q:2*BUS_Q-1]};
  bins data_2_quart = {[2*BUS_Q:3*BUS_Q-1]};
  bins data_3_quart = {[3*BUS_Q:4*BUS_Q-1]};
}
  paddr: coverpoint cov_bus.paddr_i{
  bins addr_M = {[0: 2**4]};
  bins addr_i = {[5: 2**6]};
  bins addr_j = {[7: 2**8]};
}
endgroup 

regular_test reg_tst = new;
extreme_test ext_tst = new;

//regular_test tst = new;
endmodule