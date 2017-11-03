module fifo (i_clk, i_rts_n, i_data, o_data, i_push, i_pop, o_empty, o_full);

parameter DATA_WIDTH = 8;
parameter FIFO_DEPTH = 8;
localparam FIFO_WIDTH = $clog2(FIFO_DEPTH);

input i_clk, i_rts_n, i_pop, i_push;

input [0 : DATA_WIDTH - 1] i_data;

output o_empty, o_full;

output reg [0 : DATA_WIDTH - 1] o_data;

reg [0 : FIFO_WIDTH] head, tail, counter;

reg [0 : DATA_WIDTH] data[0 : FIFO_DEPTH -1 ];

integer i;

always @(posedge i_clk or negedge i_rts_n)
if (!i_rts_n)
begin
		tail <= 0;
		head <= 0;
		counter <= 0;
		end
else
begin
	if (i_push & !o_full)
	begin
		data[head] <= i_data;
		head <= head + 1;
		counter <= counter + 1;
		if (head == FIFO_DEPTH)
		begin
			head <= 0;
			end
		end
	
	if (i_pop & !o_empty)
	begin
		o_data <= data[tail];
		tail <= tail + 1;
		counter <= counter - 1;
		if (tail == FIFO_DEPTH)
		begin
			tail <= 0;
			end
		end
	end
	
assign o_empty = (counter == 0) ? 1 : 0;
assign o_full = (counter == FIFO_DEPTH) ? 1 : 0;

endmodule
 
 function integer clogb2;
    input [31:0] value;
    begin
        value = value - 1;
        for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) 
		  begin
            value = value >> 1;
				end
    end
endfunction