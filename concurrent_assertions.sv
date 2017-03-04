`timescale 1ns/10ps

`define HALF_PERIOD  50

module concurrent_assertion(clk, cStart);

	input clk, cStart;
	reg req, gnt;

	default clocking cb1
		@(posedge clk);
	endclocking
	
	// Assertion has sequence sr1. Property pr1 is build on sequence sr1
	sequence sr1;
		req ##2 (($stable(gnt)));
	endsequence

	property pr1;
		/*@(posedge clk)*/ cStart |->sr1 ;
	endproperty

	req_gnt_assert: assert property(pr1) $display($realtime, "%m assertion passed ");
	else $fatal("%m assertion failed");
	
	

	
endmodule

// test the assertion req_gnt 
module tb;

	reg clk, cStart;

	always #`HALF_PERIOD clk = ~clk ;


	concurrent_assertion ca( .clk(clk), .cStart(cStart) );

	initial begin
		clk = 0;
		cStart = 0;
		ca.req = 0;
		ca.gnt = 0;
		//set cstart 1 on a negative clock edge
		@(negedge clk);
		cStart = 1;
		ca.req    = 1;
		
		// wait for next posdege
		@(posedge clk); //assertion starts here
		#10;
		cStart = 0;
		@(negedge clk);
		#10 ca.gnt = 1;	


		
		#5000;
		$finish;
	end
endmodule
