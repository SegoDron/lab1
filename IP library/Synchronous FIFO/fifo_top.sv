`include "fifo_if.sv"

program fifo_top(fifo_if fifo_ports);
`include "fifo_base_object.sv"
`include "fifo_driver.sv"
`include "fifo_txgen.sv"
`include "fifo_scoreboard.sv"
`include "fifo_ip_monitor.sv"
`include "fifo_output_monitor.sv"


fifo_txgen txgen;
fifo_scoreboard scrb;
fifo_ip_monitor in_mon;
fifo_output_monitor out_mon;

initial begin
	scrb = new();
	in_mon = new(scrb, fifo_ports);
	out_mon = new(scrb, fifo_ports);
	txgen = new(fifo_ports);
	
	fork
		in_mon.input_monitor();
		out_mon.output_monitor();
	join_none
	
	txgen.txgen();
	repeat (20) @(posedge fifo_ports.clk);
	scrb.error_counter();
	repeat (20) @(posedge fifo_ports.clk);
end

endprogram