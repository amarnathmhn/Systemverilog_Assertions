`timescale 1ns/10ps

`define HALF_PERIOD  50

module concurrent_assertion(clk, reset, cStart);

	input reset, clk, cStart;
	reg req, gnt;

	sequence sr1(a,b);
		a ##2 b;
	endsequence	

	property pr1( eve, pa, pb);	
		@(eve) /*disable iff (reset)*/ cStart |-> sr1(pa,pb);
	endproperty
	
	reqGnt:assert property(pr1(posedge clk,  req,gnt)) $display($realtime, "\t\t %m PASS");
	else $display($realtime, "\t\t %m FAIL");

	
endmodule

// test the assertion req_gnt 
module tb;

	reg reset, clk, cStart;

	always #`HALF_PERIOD clk = ~clk ;


	concurrent_assertion ca(.reset(reset), .clk(clk), .cStart(cStart) );

	initial begin
		clk = 0;
		reset = 1;
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
