/*--------------------------------------------------------------------
-- COPYRIGHT (c) ABC, 2024
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
-- STORES READS ALL DATA FROM SLAVE AND FROM MUL
--
--------------------------------------------------------------------
-- VHDL Dialect: VHDL '93
--
--------------------------------------------------------------------*/
`resetall
`timescale 1ns/10ps
module MatrixRegisterFile #(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 8 ,parameter SP_NTARGETS = 4, parameter ADDR_WIDTH = 16) 
(clk_i,rst_ni,write_enable,done_i,address,data_in,data_out,fin_r_o, ouflow_i ,a_row_o,b_col_o,pstrb_i,start_bit);
localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH;   // as defined
localparam LOC_ADDR_WIDTH = 9;   // the loacl address width' it's what is being transfered to theregister file 
localparam CONTROL_WIDTH = 16;          // 16 and its const
localparam SUB_ADDR = 4;                // inner add
input wire clk_i;                       // clock signal to the module
input wire rst_ni;                       // reset signal to the module
input wire write_enable;                // control if we will we can write to the module 
input wire done_i;                      //done signal
input wire [LOC_ADDR_WIDTH-1:0]address; //local address
input wire [BUS_WIDTH-1:0]data_in;      //data from slave
input wire [MAX_DIM-1:0] pstrb_i;           //strobe from slave
input wire [(MAX_DIM*MAX_DIM*BUS_WIDTH) -1 : 0] fin_r_o; //final res -> SP
input wire [MAX_DIM*MAX_DIM-1:0] ouflow_i ;      //flags from matmul
output reg [BUS_WIDTH-1:0]data_out;      //readed from RF -> slave
output reg [(MAX_DIM*BUS_WIDTH)-1:0] a_row_o; //Arows -> MUL
output reg [(MAX_DIM*BUS_WIDTH)-1:0] b_col_o; //Bcols -> MUL
output reg  start_bit;                    //control[0]
reg [DATA_WIDTH-1:0] matrix_A[MAX_DIM-1:0][MAX_DIM-1:0]; //matA
reg [DATA_WIDTH-1:0] matrix_B[MAX_DIM-1:0][MAX_DIM-1:0]; //matB
reg flags[MAX_DIM-1:0][MAX_DIM-1:0];                     //flags
reg [BUS_WIDTH-1:0] SP[SP_NTARGETS-1:0][MAX_DIM-1:0][MAX_DIM-1:0];     // this will always exist but not necessarily at this size, it needs to be changed based n the max size
reg [CONTROL_WIDTH -1:0] control;           // control register who contain the mul functions options
integer i,j,k; //for loops
genvar ii,jj,kk; // for genvar
wire [MAX_DIM*MAX_DIM-1:0] flag_o;
wire [BUS_WIDTH-1:0] res [MAX_DIM-1:0][MAX_DIM-1:0]; //to make easier read
wire [BUS_WIDTH:0] SP_wire [SP_NTARGETS-1:0][MAX_DIM-1:0][MAX_DIM-1:0]; //temp wire to calc flag
wire [BUS_WIDTH-1:0] SP_t_wire [SP_NTARGETS-1:0][MAX_DIM-1:0][MAX_DIM-1:0]; //temp wire to calc flag

for (ii = 0; ii < MAX_DIM; ii = ii + 1) begin
  for (jj = 0; jj < MAX_DIM; jj = jj + 1) begin
    assign res[ii][jj]= fin_r_o[BUS_WIDTH*(MAX_DIM*ii+jj)+:BUS_WIDTH]; //easy read
    assign flag_o[MAX_DIM*ii+jj +:1] = flags[ii][jj]; //flatten flag matrix for single output
    /////////////////////////////////////////////////////////////////////////////////////////
    //[15:14][13:12][11:10][9:8][7:6] [5:4] [3:2][1]    [0]
    //[~~~~~][--M--][--K--][-N-][~~~][srcC][tarC][+][Start]
	for (kk = 0; kk < SP_NTARGETS; kk = kk + 1) begin
	assign SP_wire[kk][ii][jj] = {SP[kk][ii][jj][BUS_WIDTH-1] , SP[kk][ii][jj]} + {res[ii][jj][BUS_WIDTH-1] , res[ii][jj]};
  assign SP_t_wire[kk][ii][jj] = SP_wire[kk][ii][jj][BUS_WIDTH-1:0]; //temp wire for flag calc
	end
  end
end
always @(*) begin: send_start_proc
   start_bit = control[0]; //send start signal to multiplier
end //send_start_proc

always @(*) begin: MEM_ORGANIZE_OUT //prepare to send to MUL
  for (i = 0; i < MAX_DIM; i = i + 1) begin
    for (j = 0; j < MAX_DIM; j = j + 1) begin
		//if(i<control[11:10] && j>control[9:8]) 
    a_row_o[DATA_WIDTH*(MAX_DIM*i+j)+:DATA_WIDTH] = matrix_A[i][j]; //& (((i>control[11:10]) | (j>control[9:8]))? {DATA_WIDTH{1'b0}}:{DATA_WIDTH{1'b1}});
    //else a_row_o[DATA_WIDTH*(MAX_DIM*i+j)+:DATA_WIDTH] = {DATA_WIDTH{1'b0}};
    //if(i<control[11:10] && j>control[13:12]) 
    b_col_o[DATA_WIDTH*(MAX_DIM*i+j)+:DATA_WIDTH] = matrix_B[i][j];// & (((i>control[11:10]) | (j>control[13:12]))? {DATA_WIDTH{1'b0}}:{DATA_WIDTH{1'b1}});
    //else b_col_o[DATA_WIDTH*(MAX_DIM*i+j)+:DATA_WIDTH] = {DATA_WIDTH{1'b0}};
    case (address[4:0])
	  0:data_out <= {{(BUS_WIDTH-CONTROL_WIDTH){1'b0}},control}; //read control
	  4:data_out[DATA_WIDTH*i+:DATA_WIDTH] <= matrix_A[address[6:5]][i]; //read by rows
	  8:data_out[DATA_WIDTH*i+:DATA_WIDTH] <= matrix_B[address[6:5]][i]; //read by cols
	  12:data_out <= flag_o;  //read flags
	  16:data_out <= SP[0][address[6:5]][address[8:7]];  //read SP1
	  20:if (SP_NTARGETS >= 2) data_out <= SP[1][address[6:5]][address[8:7]]; //read SP2 if exist
	  24:if (SP_NTARGETS == 4) data_out <= SP[2][address[6:5]][address[8:7]]; //read SP3 if exist
	  28:if (SP_NTARGETS == 4) data_out <= SP[3][address[6:5]][address[8:7]]; //read SP4 if exist
	  default:data_out <= {BUS_WIDTH{1'b0}}; //do nothing
	endcase
end end end
always @(posedge clk_i) begin: MEM_WRITE_AND_RESET //reset || to slave
if (rst_ni) begin
   control <= 16'b0; //set to zero
   for (i = 0; i < MAX_DIM; i = i + 1) begin                                                 // a loop that reset the scratchpad values as 0
      for (j = 0; j < MAX_DIM; j = j + 1) begin
         matrix_A[i][j] <=0;  //set to zero
         matrix_B[i][j] <=0;   //set to zero
         flags[i][j] <= 0;   //set to zero
		 for (k = 0; k < MAX_DIM; k = k + 1) SP[k][i][j] <= 0;
      end
   end
end
       if (control[0] == 1'b1) begin //to prevent start stuck loop
           control[0] <= 1'b0;
       end
else if (write_enable) begin
for (i =0; i < MAX_DIM; i = i + 1) begin 
      case (address[4:0])                                                                     // a case that according to the address writes to the right
            0: control <= data_in[CONTROL_WIDTH -1:0];                                                    // writing to the control register 
            4: if(pstrb_i[i]) matrix_A[address[6:5]][i]<= data_in[DATA_WIDTH*i+:DATA_WIDTH] ;  // writing to A
            8: if(pstrb_i[i]) matrix_B[address[6:5]][i]<= data_in[DATA_WIDTH*i+:DATA_WIDTH] ;  // writing to B
            default: ; //do nothing
      endcase
   end
end
  if (done_i) begin   //storing results from MUL
    for (i = 0; i < MAX_DIM; i = i + 1) begin
    for (j = 0; j < MAX_DIM; j = j + 1) begin
		//[5:4][3:2][1]
		//[src][tar][+]
		//SP[tar] <= SP[src]*[+] + res[i][j]
		SP[control[3:2]][i][j] <= SP[control[5:4]][i][j] * control[1] + res[i][j];
		if ((SP[control[3:2]][i][j][BUS_WIDTH-1] == res[i][j][BUS_WIDTH-1]) && (SP_t_wire[control[3:2]][i][j][BUS_WIDTH-1] != SP[control[3:2]][i][j][BUS_WIDTH-1])*control[1]) begin
		flags[i][j] <=1 ;
		end else begin
		  flags[i][j] <= ouflow_i[i*MAX_DIM+j]; //from pe
		end
    end
end end end
endmodule