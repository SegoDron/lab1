`include "FIFO_DUT.sv"
`include "fifo_valera.sv"
`define  VALERA
`define INITIAL_CLOCK_PERIOD_NS		10 //in ns
`timescale 1 ns / 1 ps

module fifo_tb ();
parameter WIDTH_DATA = 8;
parameter DEPTH		 = 16;
wire [WIDTH_DATA - 1 : 0] data_in;
wire [WIDTH_DATA - 1 : 0] data_out;
wire push, pop, empty, full;
reg clk, rst_n;

initial	
	begin: clk_generator
		clk = 0;
		#5;
		
		forever	#5 clk = ~clk;
		
	end: clk_generator

initial
		begin: rst_generator
			rst_n = 0;
			#5;
			rst_n = 1;
			
		end: rst_generator
	
fifo_if ports(.clk 	 	(clk	 	),
			  .data_in 	(data_in	),
			  .pop     	(pop	 	),
			  .push	 	(push   	),
			  .data_out (data_out	),
			  .empty	(empty		),
			  .full		(full		));
	
fifo_top top(ports);

`ifdef VALERA

fifo_valera #(.FIFO_DEPTH (DEPTH)) dut(.i_clk			(clk		),
										 .i_data		(data_in	),
										 .i_pop			(pop		),
										 .i_push	    (push		),
										 .o_data		(data_out	),
										 .o_empty   	(empty		),
										 .o_full		(full		),
										 .i_rts_n		(rst_n		)); 
`else
										 
FIFO_DUT #(.WIDTH_DATA (WIDTH_DATA)) dut(.i_clk			(clk		),
										 .i_data_in		(data_in	),
										 .i_pop			(pop		),
										 .i_push	    (push		),
										 .o_data_out	(data_out	),
										 .o_empty   	(empty		),
										 .o_full		(full		),
										 .i_rst_n		(rst_n		));
`endif										 
	
endmodule: fifo_tb