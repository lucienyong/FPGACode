module ledkey(
	clk,
	rst_n,
	keyin,
	led
	);
	
	input clk;
	input rst_n;
	input [3:0]keyin;
	
	output reg [3:0]led;
		
//	parameter CNTMAX = 20'd999_999;//20ms
	parameter CNTMAX = 20'd9_999;
	
	reg [3:0]keyin_ra,keyin_rb;
	reg [19:0]cnt;
	wire [3:0]keyflag;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)begin 
		cnt <= 20'd0;
		keyin_ra <= 4'b1111;
		keyin_rb <= 4'b1111;
	end 
	else if(cnt==CNTMAX)begin 
		cnt <= 20'd0;
		keyin_ra <= keyin;
	end 
	else begin 
		cnt <= cnt + 1'b1;
		keyin_rb <= keyin_ra; 
	end 

	assign keyflag = keyin_rb & (~keyin_ra);
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		led <= 4'b1111;
	else if(keyflag)begin 
		led <= ~led;
	end 
	else 
		led <= led;
		
endmodule 
