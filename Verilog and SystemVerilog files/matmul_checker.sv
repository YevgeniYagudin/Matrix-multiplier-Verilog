//
// Verilog Module my_projectsasas_lib.matmul_checker
//
// Created:
//          by - Eugene.UNKNOWN (DESKTOP-BCGV2R3)
//          at - 11:31:42 23-Feb-24
//
// using Mentor Graphics HDL Designer(TM) 2021.1 Built on 14 Jan 2021 at 15:11:42
//

`resetall
`timescale 1ns/10ps
module matmul_checker #(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 16 ,parameter SP_NTARGETS = 4 )
(
  matmul_intf.matmul_checker check_bus
);
///////////////////////////////////////////////////////////////////////////////

property penable_active;
  @(check_bus.penable_i) check_bus.penable_i==1 |=> (check_bus.prdata_o >= 0)||(check_bus.prdata_o <= 2^BUS_WIDTH-1);
endproperty 
assert property(penable_active)
  else $error("error with penable %d %d",check_bus.penable_i , check_bus.prdata_o);
  cover property(penable_active);
///////////////////////////////////////////////////////////////////////////////

property reset_err;
  @(check_bus.rst_ni) check_bus.rst_ni == 1 |-> check_bus.pslverr_o !== 1;
endproperty 
assert property(reset_err)
  else $error("error with error at reset");
  cover property(reset_err);
///////////////////////////////////////////////////////////////////////////////
property reset_ready;
  @(check_bus.rst_ni) check_bus.rst_ni == 1 |-> check_bus.pready_o !== 1;
endproperty 
assert property(reset_ready)
  else $error("error with ready at reset");
  cover property(reset_ready);
///////////////////////////////////////////////////////////////////////////////
property reset_data_out;
  @(check_bus.rst_ni) check_bus.rst_ni == 1 |-> check_bus.prdata_o !== 1;
endproperty 
assert property(reset_data_out)
  else $error("data no zero at reset");
  cover property(reset_data_out);
///////////////////////////////////////////////////////////////////////////////
property reset_active;
  @(check_bus.rst_ni) check_bus.rst_ni==1 |-> (check_bus.prdata_o == 0);
endproperty 
assert property(reset_active)
  else $error("error with reset");
  cover property(reset_active);
///////////////////////////////////////////////////////////////////////////////


endmodule
