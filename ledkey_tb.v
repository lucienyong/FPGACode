`timescale 1ns/1ns
`define clk_period 20

module ledkey_tb;

	reg clk;
	reg rst_n;
	reg keyin;
	
	wire led;
	
	ledkey U1(
	.clk(clk),
	.rst_n(rst_n),
	.keyin(keyin),
	.led(led)
	);
	
	initial clk = 1;
	always #(`clk_period/2)clk = ~clk;
	
	reg [15:0]keyrandom;
	
	initial begin 
	rst_n = 0;
	#(`clk_period*20+1);
	rst_n = 1;
	repeat(5)begin 
		keyin = 1;
		repeat(20)begin 
			keyrandom = {$random}%4095;
			#keyrandom keyin = ~keyin;
		end 
		keyin = 0;
		#(`clk_period*50000);
		keyin = 1;
		repeat(20)begin 
			keyrandom = {$random}%4095;
			#keyrandom keyin = ~keyin;
		end 
		keyin = 1;
		#(`clk_period*50000);
	end 
	$stop;
	end 
	
endmodule 
