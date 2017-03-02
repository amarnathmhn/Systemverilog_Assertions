
`timescale 1ns/10ps
`define HALF_PERIOD 50.5

module tb;

	reg clk;
	
	// setup clock
	always #`HALF_PERIOD clk = ~clk;

	initial begin
		clk = 0;
		#1000;
		$finish;	
	end
endmodule
