
`timescale 1ns/10ps
`define HALF_PERIOD 50

module immediate_assertion(clk, a, b, c, d);
	input clk;
	input a;
	input b;
	input c;
	input d;

	always @(posedge clk)begin
		if (a) begin
			@(posedge d); //wait for posedge of d
			aORb : assert (b || c) $display($stime,"%m assert passed\n");
			else 
				$warning($stime,"%m assert failed");
		end
	end
endmodule

// test the immediate assertion
module tb;

	reg clk;
	reg a,b,c,d;

	immediate_assertion ia(.clk(clk), .a(a), .b(b), .c(c), .d(d) );
	
	// setup clock
	always #`HALF_PERIOD clk = ~clk;

	initial begin
		clk = 0;
		a = 0;
		b = 0;
 		c = 0;
		d = 0;
		#100;
		a = 1;
		#150;
		d = 1; // posedge occurs here
		// assertion should fail if the next line is commented
		//b = 1; c= 1;
		#500;	
		$finish;	
	end
endmodule
