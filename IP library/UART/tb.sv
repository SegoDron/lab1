`timescale 1 ns / 1 ps

module tb;
reg [11:0] 	data;
reg 		sys_clk;
reg			new_spd;
reg			rst;
wire		clk_en;

uart_clock_gen clk_gen(.i_data (data),
						.i_sys_clk (sys_clk),
						.i_new_spd	(new_spd),
						.i_rst_n	(rst),
						.o_clk_en	(clk_en));
						
initial 
begin
	sys_clk = 0;
	forever #5 sys_clk = !sys_clk;
end

initial
begin
	rst = 0;
	@(negedge sys_clk) rst = 1;
end

initial
begin
	new_spd = 1;
	data = 9;
	#20 new_spd = 0;
	#1000;
	new_spd = 1;
	data = 5;
	#1000 $finish;
end

endmodule