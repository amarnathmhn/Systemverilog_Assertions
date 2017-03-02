// Timescale directive is : `timescale unit/precision
// unit is the time for #1 delays. if unit = 1ns, the #12 means 12ns
// precision describes the accuracy of the simulation time. If precision = 10ps, then 
// the delays are rounded to nearest 10ps. 
// eg. `timescale 1ns/10ps means that #12.456 rounds to 12456 ps / 10 ps = 1245.6 = 1246 ticks = 12460 ps = 12.46 ns

// The file is thanks to vlsi.pro/verilog-timescales

// Remove comment for the timescale you want to test.

`timescale 1ps/1ps
//`timescale 1ns/1ps
//`timescale 100ns/1ns
//`timescale 1ms/1us
//`timescale 10ms/10ns

module timescale_check;

 reg[31:0] rval;

 initial begin

 	rval = 20;
	#10.56601 rval = 10;
	#10.98003 rval = 55;
	#15.674   rval = 0;
	#5.0000001 rval = 250;
	#5.67891224 rval = 100;
 end
 
 initial begin
	// Print the timescale under use
	$printtimescale($root.timescale_check);
	// Print out any changes in rval
 	$monitor("Time=%0t, rval = %d\n",$realtime,rval );
	#100 $finish;
 end

endmodule

