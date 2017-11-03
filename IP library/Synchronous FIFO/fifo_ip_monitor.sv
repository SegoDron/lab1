`ifndef FIFO_IP_MONITOR
`define FIFO_IP_MONITOR

`include "fifo_base_object.sv"
`include "fifo_scoreboard.sv"
`include "fifo_if.sv" 

class fifo_ip_monitor;
	fifo_base_object fifo_object;
	fifo_scoreboard	 fifo_scbrd ;
	virtual fifo_if  fifo_ports ;
	
	function new(fifo_scoreboard fifo_scbrd, virtual fifo_if fifo_ports);
		begin
			this.fifo_scbrd = fifo_scbrd;
			this.fifo_ports = fifo_ports;
		end
	endfunction
	
	task input_monitor();
		begin
			while (1)
				begin
					@(negedge fifo_ports.clk);
					if (fifo_ports.push && !fifo_ports.full) begin
						fifo_object = new();
					//	$display ("Input monitor: FIFO write access -> DATA: %x\n", fifo_ports.data_in);
						fifo_object.data = fifo_ports.data_in;
						fifo_object.pop = 0;
						fifo_object.push = 0;
						fifo_scbrd.post_input(fifo_object);
					end
				end
		end
	endtask

endclass

`endif