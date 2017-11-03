//Design description:
//Synchronous FIFO

`timescale 1 ns / 1 ps

module FIFO_DUT #(
parameter WIDTH_DATA = 8) (
input								i_clk		,
input	  							i_rst_n		,
input 		 [WIDTH_DATA - 1 : 0] 	i_data_in 	,
input								i_pop		,
input								i_push		,
output logic [WIDTH_DATA - 1 : 0] 	o_data_out	,
output								o_empty		,
output								o_full
);

parameter ADDR_WIDTH = 4;
parameter RAM_WIDTH  = (1 << ADDR_WIDTH);

logic [ADDR_WIDTH - 1 : 0] wr_ptr						;	//Write pointer
logic [ADDR_WIDTH - 1 : 0] rd_ptr						;	//Read pointer
logic [ADDR_WIDTH	  : 0] status_cnt					;	//Status counter
logic [WIDTH_DATA - 1 : 0] data_ram	[RAM_WIDTH - 1 : 0]	;	//Words buffer

//FIFO flags
assign o_empty = (status_cnt == 0		  );
assign o_full  = (status_cnt == RAM_WIDTH);

//Status counter
always @(posedge i_clk or negedge i_rst_n)
	if (!i_rst_n)
		status_cnt <= 0;
	else if ((!o_empty && i_pop) && (!o_full && i_push))
		status_cnt <= status_cnt;
	else if (!o_empty && i_pop)
		status_cnt <= status_cnt - 1;
	else if (!o_full && i_push)
		status_cnt <= status_cnt + 1;

//POP operation		
always @*
	o_data_out = data_ram [rd_ptr];

		
//PUSH operation
always @(posedge i_clk)
	if (i_push && !o_full)
		data_ram [wr_ptr] <= i_data_in;
	else if (o_empty)
		data_ram [rd_ptr] <= 0;
		
//Read and Write Pointers
always @(posedge i_clk or negedge i_rst_n)
	if (!i_rst_n)
		begin
			rd_ptr <= 0;
			wr_ptr <= 0;
		end
	else
		begin
			if (i_pop && !o_empty)
				rd_ptr <= rd_ptr + 1;
			if (i_push && !o_full)
				wr_ptr <= wr_ptr + 1;
		end
		
endmodule: FIFO_DUT



















	