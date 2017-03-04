`timescale 1ns/10ps

`define HALF_PERIOD  50

module concurrent_assertion(clk, cStart);

	input clk, cStart;
	reg req, gnt;
	
	// Assertion has sequence sr1. Property pr1 is build on sequence sr1

	// Sequence says gnt must be high between 1:5 cycles of req being high
	sequence sr1;
		req ##[1:5] gnt;
	endsequence

	property pr1;
		@(posedge cStart) cStart |->sr1 ;
	endproperty

	req_gnt_assert: assert property(pr1) $display($realtime, "%m assertion passed ");
	else $fatal("%m assertion failed");
endmodule

module tb;

	reg clk, cStart;

	always #`HALF_PERIOD clk = ~clk ;


	concurrent_assertion ca( .clk(clk), .cStart(cStart) );

	initial begin
		clk = 0;
		cStart = 0;
		ca.req = 0;
		ca.gnt = 0;
		#100;
		cStart = 1;
		ca.req = 1;
		// ca.gnt = 1in two clock cycles exactly
		@(posedge clk);
		repeat(2) @(posedge clk);
	
		ca.gnt = 1;
		#500;
		$finish;
	end
endmodule
