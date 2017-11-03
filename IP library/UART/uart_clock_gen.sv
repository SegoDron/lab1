`timescale 1 ns / 1 ps

module uart_clock_gen(
input				i_sys_clk	,
input				i_rst_n		,
output logic 		o_clk_en	);

logic [11:0] 	dwn_cnt	;		
logic [15:0]	ubrr	;

assign ubrr = uart_top.uart_wb_slave.ubrr_r;

always @(posedge i_sys_clk or negedge i_rst_n)
if (!i_rst_n) begin
	dwn_cnt		<= 0;
	o_clk_en	<= 0;
end
else begin
	if (dwn_cnt == 0) begin
		dwn_cnt 	<= ubrr [11:0];
		o_clk_en	<= 1;
	end
	else begin
		dwn_cnt 	<= dwn_cnt - 1;
		o_clk_en	<= 0;
	end
end

endmodule: uart_clock_gen