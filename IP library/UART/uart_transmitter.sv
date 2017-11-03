`timescale 1 ns / 1 ps

module uart_transmitter(
input 					i_sys_clk	,
input					i_clk_en 	,
input					i_rst_n		,
input  			[7:0]	i_tx_data	,
input					i_tx_en		,
input					i_ld_tx_data,
output logic			o_tx		,
output logic			o_tx_empty	);

logic [7:0] tx_reg ;
logic [3:0]	tx_cnt ;

always @(posedge i_sys_clk or negedge i_rst_n)
if(!i_rst_n)
	begin
		o_tx_empty 	<= 1;
		o_tx		<= 1;
		tx_cnt  	<= 0;
		tx_reg  	<= 0;
	end
else if (i_clk_en)
	begin
		if (o_tx_empty && i_ld_tx_data)
			begin
				tx_reg     <= i_tx_data;
				o_tx_empty <= 0;
			end
		else if (tx_cnt == 9)
			o_tx_empty <= 1;
		
		if (i_tx_en && !o_tx_empty)
			begin
				tx_cnt <= tx_cnt + 1;
				if (tx_cnt == 0)
					o_tx 		<= 0;
				else if (tx_cnt > 0 && tx_cnt < 9)
					o_tx <= tx_reg [tx_cnt - 1];
				else if (tx_cnt == 9)
					begin
						tx_cnt 	  <= 0;
						o_tx	  <= 1;
					end
			end
		
		else if (!i_tx_en)	
			begin	
				tx_cnt 		<= 0;
				o_tx_empty 	<= 1;
			end
	end

endmodule: uart_transmitter
