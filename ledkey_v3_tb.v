`timescale 1ns/1ns
`define clk_period 20

module ledkey_tb;

	reg clk;
	reg rst_n;
	reg [3:0]keyin;
	
	wire [3:0]led;
	
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
		keyin = 4'b1111;
		repeat(20)begin 
			keyrandom = {$random}%499;
			#keyrandom keyin = ~keyin;
		end 
		keyin = 4'b0000;
		#(`clk_period*50000);
		keyin = 4'b1111;
		repeat(20)begin 
			keyrandom = {$random}%499;
			#keyrandom keyin = ~keyin;
		end 
		keyin = 4'b1111;
		#(`clk_period*50000);
	end 
	$stop;
	end 
	
endmodule 
