`timescale 1 ns / 1 ps

module uart_top(
input					i_we		,	//0 - read from slave, 1 - write to slave
input					i_sys_clk	,	//system clock
input					i_arst_n	,	//asynchronous reset with active low level
input					i_srst		,	//synchronous reset with active high level
input			[7 :0]	i_data_in	,	//input data
input					i_stb		,	//1 - active operation
input					i_cyc		,	//1 - start of read or write
input  			[2 :0]	i_add		,	//addres of register
input 					i_rx		,	//receiver output
output logic			o_tx		,	//transmitter output
output logic			o_ack		,	//1 - operation finished
output logic	[7 :0]  o_data_out  ,	//output data
);

logic [7:0] rx_fifo_data_in ;	//for rx FIFO
logic [7:0] rx_fifo_data_out;
logic 		rx_fifo_pop		;
logic   	rx_fifo_push	;
logic		rx_fifo_empty	;
logic		rx_fifo_full	;

logic [7:0] tx_fifo_data_in ;	//for tx FIFO
logic [7:0] tx_fifo_data_out;
logic 		tx_fifo_pop		;
logic   	tx_fifo_push	;
logic		tx_fifo_empty	;
logic		tx_fifo_full	;

logic		clk_en			;	//for clock generator

logic		tx_en			;	//for transmitter
logic		ld_tx_data		;
logic		tx_empty		;

logic		rx_en			;	//for receiver
logic		uld_rx_data		;
logic		rx_busy			;
logic		rx_empty		;
logic		rx_frame_err	;	

assign {uld_rx_data, rx_en, ld_tx_data, tx_en} = uart_wb_slave.uctrl_r [3:0];

assign uart_wb_slave.ufout_r = {tx_empty, tx_fifo_full, tx_fifo_empty, rx_frame_err, 
								rx_empty, rx_busy, rx_fifo_full, rx_fifo_empty};

assign rx_fifo_push = uld_rx_data && !rx_busy;

assign tx_fifo_pop = tx_empty && ld_tx_data;

FIFO_DUT		uart_fifo_rx	   (.i_clk				(i_sys_clk			),
									.i_rst_n			(i_arst_n  			),
									.i_data_in 			(rx_fifo_data_in	),
									.i_pop				(rx_fifo_pop		),
									.i_push				(rx_fifo_push		),
									.o_data_out			(rx_fifo_data_out	),
									.o_empty			(rx_fifo_empty		),
									.o_full				(rx_fifo_full		));
									
FIFO_DUT		uart_fifo_tx	   (.i_clk				(i_sys_clk			),
									.i_rst_n			(i_arst_n  			),
									.i_data_in 			(tx_fifo_data_in	),
									.i_pop				(tx_fifo_pop		),
									.i_push				(tx_fifo_push		),
									.o_data_out			(tx_fifo_data_out	),
									.o_empty			(tx_fifo_empty		),
									.o_full				(tx_fifo_full		));
									
wb_slave		uart_wb_slave		(.i_we		 		(i_we				),	
									 .i_sys_clk	 		(i_sys_clk			),
									 .i_arst_n	 		(i_arst_n			),
									 .i_srst	 		(i_srst				),	 
									 .i_data_in	 		(i_data_in			),	
									 .i_stb		 		(i_stb				),	
									 .i_cyc		 		(i_cyc				),	
									 .i_add		 		(i_add				),	
									 .o_ack		 		(o_ack				),	
									 .o_data_out 		(o_data_out			));
									 
uart_clock_gen	uart_clk_gen		(.i_sys_clk	 		(i_sys_clk			),
									 .i_rst_n	 		(i_arst_n			),
									 .o_clk_en  		(clk_en				));
									 
uart_transmitter uart_tx			(.i_sys_clk			(i_sys_clk			),
									 .i_clk_en 			(clk_en				),
									 .i_rst_n			(i_arst_n			),
									 .i_tx_data			(tx_fifo_data_out	),
									 .i_tx_en			(tx_en				),
									 .i_ld_tx_data		(ld_tx_data			),
									 .o_tx				(o_tx				),
									 .o_tx_empty		(tx_empty			));
									 
uart_receiver 	uart_rx				(.i_sys_clk			(i_sys_clk			),
									 .i_clk_en 			(clk_en				),
									 .i_rst_n			(i_arst_n			),
									 .i_rx				(i_rx				),
									 .i_rx_en			(rx_en				),
									 .i_uld_rx_data		(uld_rx_data		),		
									 .o_rx_data			(rx_fifo_data_in	),
									 .o_rx_empty		(rx_empty			),
									 .o_rx_busy			(rx_busy			),
									 .o_rx_frame_err	(rx_frame_err		));	

endmodule: 	uart_top								 
									 
									 
									 
									 
									 
									 
									 
									 
									 