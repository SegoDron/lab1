`timescale 1 ns / 1 ps

module uart_receiver(
input 					i_sys_clk		,
input					i_clk_en 		,
input					i_rst_n			,
input					i_rx			,
input					i_rx_en			,
input					i_uld_rx_data	,		//pop in FIFO
output logic [7:0]		o_rx_data		,
output logic			o_rx_empty		,
output logic			o_rx_busy		,
output logic			o_rx_frame_err	);

logic [3:0]	rx_cnt	;

always @(posedge i_sys_clk or negedge i_rst_n)
if (!i_rst_n) begin
	o_rx_busy  		<= 0;
	o_rx_empty 		<= 1;
	o_rx_data 		<= 0;
	o_rx_frame_err	<= 0;
	rx_cnt			<= 0;
end
else if (i_clk_en) begin
	if (i_uld_rx_data && !o_rx_busy)
		o_rx_empty <= 1;
	else if (i_rx_en) begin
		if (!o_rx_busy && !i_rx) begin
			o_rx_busy 		<= 1;
			rx_cnt 			<= 0;
			o_rx_frame_err	<= 0;
		end	
		else if (o_rx_busy) begin
			rx_cnt <= rx_cnt + 1;
			if (rx_cnt < 8)
				o_rx_data [rx_cnt] <= i_rx;
			else if (rx_cnt == 8) begin
				rx_cnt 		<= 0;
				o_rx_busy	<= 0;
				if (!i_rx)
					o_rx_frame_err <= 1;
				else 
					o_rx_empty <= 0;
			end
					
		end	
	end
	else if (!i_rx_en) begin
		o_rx_busy <= 0;
	end
end
endmodule: uart_receiver
