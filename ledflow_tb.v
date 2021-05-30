`timescale 1ns/1ns
`define clk_period 20

module ledflow_tb;

	reg clk;
	reg rst_n;
	
	wire [3:0]led;
	
	ledflow U1(
		.clk(clk),
		.rst_n(rst_n),
		.led(led)
		);
		
	initial clk = 1;
	always #(`clk_period/2)clk = ~clk;
	
	initial begin 
		rst_n = 0;
		#(`clk_period*20+1);
		rst_n = 1;
		#(`clk_period*42_000);
		$stop;
	end 
	
endmodule 
