`timescale 1 ns / 1 ps

module wb_slave(
input					i_we		,	//0 - read from slave, 1 - write to slave
input					i_sys_clk	,	//system clock
input					i_arst_n	,	//asynchronous reset with active low level
input					i_srst		,	//synchronous reset with active high level
input			[7 :0]	i_data_in	,	//input data
input					i_stb		,	//1 - active operation
input					i_cyc		,	//1 - start of read or write
input  			[2 :0]	i_add		,	//addres of register
output logic			o_ack		,	//1 - operation finished
output logic	[7 :0]  o_data_out  ,	//output data
);
logic	[7 :0] fifo_out	;	//address = 4
logic	[7 :0] fifo_in	;
logic	[15:0] ubrr_r 	;	//UART Baud Rate Register, address = 0 - UBRRL, address = 1 - UBRRH
logic	[7 :0] uctrl_r	;	//UART Control Register, address = 2
logic	[7 :0] ufout_r 	;	//UART Flag Register, address = 5

/********************uctrl register*******************
4-7 bits: recerved
3 bit: uld_rx_data 
2 bit: rx_en
1 bit: ld_tx_data
0 bit: tx_en
*/

/********************ufout register*******************
7 bit:	tx_empty
6 bit:	tx_fifo_empty
5 bit:	tx_fifo_full
4 bit:	rx_frame_err
3 bit:	rx_empty
2 bit:	rx_full
1 bit:	rx_fifo_full
0 bit:	rx_fifo_empty
*/

logic		   ack		;	//1 period delay for o_ack

always @(posedge i_sys_clk or negedge i_arst_n)
begin
	if (!i_arst_n) begin
		ubrr_r  	<= 0;
		uctrl_r 	<= 0;
		uart_top.uart_fifo_rx.rx_fifo_pop  <= 0;
		uart_top.uart_fifo_tx.tx_fifo_push <= 0;
		o_ack		<= 0;
		ack			<= 0;
	end	
	else if (i_srst) begin
		ubrr_r  	<= 0;
		uctrl_r 	<= 0;
		o_fifo_pop  <= 0;
		o_fifo_push <= 0;
		o_ack		<= 0;
		ack			<= 0;
	end	
	else begin
		uart_top.rx_fifo_pop  <= 0;
		uart_top.tx_fifo_push <= 0;
		ack			<= 0;
				
		if (i_stb && i_cyc) begin
			if (!i_we) begin										//read operation
				case (i_data)
					4: begin
						o_data_out 	<= uart_top.rx_fifo_data_out;	//read received data from FIFO
						uart_top.rx_fifo_pop 	<= 1		 ;					
					end
					5: o_data_out <= ufout_r;						//read UART Flag Register 
				endcase
				ack 	   	<= 1;
			end
			
			else if (we)											//write operation
				case (i_add)
					0: ubrr_r [7 :0] <= i_data_in;					//write to UBRRL
					1: ubrr_r [15:8] <= i_data_in;					//write to UBRRH
					2: uctrl_r		 <= i_data_in;					//write to UART Contral Register 
					3: begin
						uart_top.tx_fifo_data_in 	<= i_data_in;	//write new data to FIFO for transmitting
						uart_top.tx_fifo_push 	  	<= 1		;
					end
				endcase
				ack			<= 1;	
			end
		end
		o_ack		<= ack;
	end
end

endmodule: wb_slave