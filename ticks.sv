`timescale 10ns/10ps

module tb;

reg rval;

initial begin
	#2 rval = 0;
end
initial begin
	$monitor("t = %t, \trval = %d",$realtime, rval);
end
endmodule
