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
	
	reg  [3:0]keyin_ra,keyin_rb;
	reg  [19:0]cnt;
	reg  cnt_done;
	reg  en_cnt;
	wire [3:0]nedge;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		en_cnt <= 1'b0;
	else if(nedge)
		en_cnt <=1'b1;
	else if(cnt<CNTMAX)
		en_cnt <= en_cnt;
	else 
		en_cnt <= 1'b0;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)begin 
		cnt <= 20'd0;
		cnt_done <= 1'b0;
	end 
	else if(en_cnt)begin  
		if(cnt==CNTMAX)begin
			cnt_done <= 1'b1;
			cnt      <= 20'd0;
		end 
		else begin
			cnt <= cnt + 1'b1;
			cnt_done <= 1'b0;
		end 
	end 
	else begin 
		cnt <= 20'd0;
		cnt_done <= 20'd0;
	end 
		
	always@(posedge clk or negedge rst_n)
	if(!rst_n)begin 
		keyin_ra <= 4'b1111;
		keyin_rb <= 4'b1111;
	end 
	else begin 
		keyin_ra <= keyin;
		keyin_rb <= keyin_ra;
	end 
	
	assign nedge = keyin_rb & (~keyin_ra);
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		led <= 4'b1111;
	else if(cnt_done&&(keyin_rb!=4'b1111))begin 
		led <= ~led;
	end 
	else 
		led <= led;
		
endmodule 
