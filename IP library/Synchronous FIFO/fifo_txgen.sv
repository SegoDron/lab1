`ifndef FIFO_TXGEN
`define FIFO_TXGEN

`include "fifo_base_object.sv"
`include "fifo_driver.sv"

class fifo_txgen;
	fifo_base_object fifo_object;
	fifo_driver		 fifo_drv	;
	
	int cnt_cmd;
	
function new(virtual fifo_if fifo_ports);
	begin
		cnt_cmd     = 100;
		fifo_drv    = new(fifo_ports);
		fifo_object = new;
	end
endfunction

task txgen;
	begin
		int i;
		fifo_object.push = 0;
		fifo_object.pop  = 0;
		for (i = 0; i < cnt_cmd; i++)
			begin
				fifo_object.data = $random();
				if (i > 40)
					fifo_object.push = 0;
				else
					fifo_object.push = 1;
				if ((i > 5) && (i < 20))
					fifo_object.pop = 1;
				else if ((i >= 20) && (i < 60))
					fifo_object.pop = 0;
				else if (i >= 60)
					fifo_object.pop = 1;
				
				fifo_drv.driver(fifo_object);
			end
	end
endtask

endclass

`endif