`timescale 1ns/10ps

`define HALF_PERIOD  50

module Design(dclk, dcStart);
	input dclk, dcStart;
	reg dreq, dgnt;

endmodule


module concurrent_assertion(clk, cStart, req, gnt);


	input clk, cStart;
	input req, gnt;

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


	// instantiate the design first
	Design d(.dclk(clk), .dcStart(cStart));

	// bind the property by connecting property module to design module
	bind d concurrent_assertion ca(.clk(dclk), .cStart(dcStart), .req(dreq), .gnt(dgnt));

	initial begin
		clk = 0;
		cStart = 0;
		d.dreq = 0;
		d.dgnt = 0;
		//set cstart 1 on a negative clock edge
		@(negedge clk);
		cStart = 1;
		d.dreq    = 1;
		
		// wait for next posdege
		@(posedge clk); //assertion starts here
		#10;
		cStart = 0;
		@(negedge clk);
		#10 d.dgnt = 1;	


		
		#5000;
		$finish;
	end
endmodule
