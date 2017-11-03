`ifndef FIFO_BASE_OBJECT
`define FIFO_BASE_OBJECT

class fifo_base_object;
	bit [7 : 0] data;
	bit			pop ;
	bit			push;
	bit			full;
	bit			empty;
endclass

`endif