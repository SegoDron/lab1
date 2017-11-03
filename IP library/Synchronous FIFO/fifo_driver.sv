`ifndef FIFO_DRIVER
`define FIFO_DRIVER

`include "fifo_if.sv"
`include "fifo_base_object.sv"


class fifo_driver;
	virtual fifo_if fifo_ports;
	
	function new(virtual fifo_if fifo_ports);
		begin
			this.fifo_ports = fifo_ports;
			fifo_ports.data_in = 0;
			fifo_ports.push	 = 0;
			fifo_ports.pop	 = 0;
		end
	endfunction
	
	task driver(fifo_base_object fifo_object);
		begin
			@(posedge fifo_ports.clk);
			fifo_ports.data_in = fifo_object.data;
			fifo_ports.push = fifo_object.push;
			fifo_ports.pop = fifo_object.pop;		
		/*	if (fifo_object.push && !fifo_ports.full)
				$display("Driver: FIFO write access -> Data: %x\n",
					fifo_object.data);
			if (fifo_object.pop && !fifo_ports.empty)
				$display("Driver: FIFO read access \n");*/
			@(posedge fifo_ports.clk);
			fifo_ports.data_in = 0;
			fifo_ports.push = 0;
			fifo_ports.pop = 0;	
		end
	endtask
	
endclass

`endif