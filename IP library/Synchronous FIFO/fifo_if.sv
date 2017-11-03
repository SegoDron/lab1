//Interface of synchronous FIFO
`ifndef FIFO_PORTS
`define FIFO_PORTS

interface fifo_if(
input					clk			,
output logic [7 : 0] 	data_in 	,
output logic			pop			,
output logic			push		,
input  logic [7 : 0] 	data_out	,
input  logic			empty		,
input  logic			full
);
endinterface

`endif