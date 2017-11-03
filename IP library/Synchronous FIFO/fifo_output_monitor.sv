`ifndef FIFO_OUTPUT_MONITOR
`define FIFO_OUTPUT_MONITOR

`include "fifo_base_object.sv"
`include "fifo_scoreboard.sv"
`include "fifo_if.sv"

class fifo_output_monitor;
	fifo_base_object fifo_objects;
	fifo_scoreboard	 fifo_scbrd ;
	virtual fifo_if  fifo_ports ;
	
	function new(fifo_scoreboard fifo_scbrd, virtual fifo_if fifo_ports);
		begin
			this.fifo_scbrd = fifo_scbrd;
			this.fifo_ports = fifo_ports;
		end
	endfunction
	
	task output_monitor();
		begin
			while (1)
				begin
					@(negedge fifo_ports.clk);
					if (fifo_ports.pop && !fifo_ports.empty) begin
							fifo_objects = new();
							//$display ("Output monitor: FIFO read access \n");
							fifo_objects.data = fifo_ports.data_out;
							fifo_scbrd.post_output(fifo_objects);
					end
					@(posedge fifo_ports.clk);
							fifo_objects = new();
							fifo_objects.full = fifo_ports.full;
							fifo_objects.empty = fifo_ports.empty;
							fifo_scbrd.fifo_flags_checker(fifo_objects);
				end
		end	
	endtask
	
endclass

`endif 