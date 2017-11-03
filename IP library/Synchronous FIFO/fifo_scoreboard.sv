`ifndef FIFO_SCOREBOARD
`define FIFO_SCOREBOARD

`include "fifo_base_object.sv"
`include "fifo_if.sv"

class fifo_scoreboard;
	fifo_base_object fifo_object[$];		//Create an queue
	
	fifo_base_object inp_objct;
	fifo_base_object fifo_flags;
	
	function new();
		begin
			fifo_flags = new;
		end
	endfunction
	
	int error_cnt 		;
	int error_cnt_flags ;
	
	task post_input(fifo_base_object fifo_obj);
		begin
			fifo_object.push_back(fifo_obj);
		end
	endtask
	
	task post_output(fifo_base_object output_object);
		begin
				fifo_base_object in_fifo = fifo_object.pop_front;
				//$display("Scoreboard: Found new data!");
				if (in_fifo.data != output_object.data) begin
					$display("[%0t]Scoreboard: ERROR!!\n", $time);
					$display("Expected data: %x\n", in_fifo.data);
					$display("Got data: %x\n", output_object.data);
					error_cnt = error_cnt + 1;
				end
				//else
				//	$display("Scoreboard: Exp data and Got data match");
		end
	endtask
	
	task fifo_flags_checker (fifo_base_object fifo_flags_got);
		begin
			if (fifo_object.size == 0)
				begin
					fifo_flags.full  = 0;
					fifo_flags.empty = 1;
				end
			else if (fifo_object.size == 16)
				begin
					fifo_flags.full  = 1;
					fifo_flags.empty = 0;
				end
			else
				begin
					fifo_flags.full  = 0;
					fifo_flags.empty = 0;
				end
		
			if (fifo_flags.full !== fifo_flags_got.full) begin
				$display("[%0t]Scoreboard: ERROR with full flag!\n", $time);
				$display("Expected flag: %x\n", fifo_flags.full);
				$display("Got flag: %x\n", fifo_flags_got.full);
				error_cnt_flags = error_cnt_flags + 1;
			end	
			else if (fifo_flags.empty !== fifo_flags_got.empty) begin
				$display("[%0t]Scoreboard: ERROR with empty flag!\n", $time);
				$display("Expected flag: %x\n", fifo_flags.empty);
				$display("Got flag: %x\n", fifo_flags_got.empty);
				error_cnt_flags = error_cnt_flags + 1;
			end	
			//else	$display("Scoreboard: Got and expected flags match");
		end
	endtask
	
	task error_counter();
		begin
			if (error_cnt != 0)
				$display("Scoreboard: Tests faild! Error counter = %d\n", error_cnt);
			else if (error_cnt_flags != 0)
				$display("Scoreboard: Tests faild! Flags don`t expected. Flags error counter = %d\n", error_cnt_flags);
			else
				$display("Scoreboard: Tests complite!");
		end
	endtask
	
endclass

`endif