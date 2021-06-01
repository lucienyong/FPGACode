module ledkey_top(
	clk,
	rst_n,
	keyin,
	led
	);
	
	input clk;
	input rst_n;
	input [3:0]keyin;
	
	output [3:0]led;
	
	ledkey U1(
	.clk(clk),
	.rst_n(rst_n),
	.keyin(keyin[0]),
	.led(led[0])
	);
	
	ledkey U2(
	.clk(clk),
	.rst_n(rst_n),
	.keyin(keyin[1]),
	.led(led[1])
	);
	
	ledkey U3(
	.clk(clk),
	.rst_n(rst_n),
	.keyin(keyin[2]),
	.led(led[2])
	);
	
	ledkey U4(
	.clk(clk),
	.rst_n(rst_n),
	.keyin(keyin[3]),
	.led(led[3])
	);
	
endmodule 
