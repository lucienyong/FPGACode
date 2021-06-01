//module ledkey.v
module ledkey(
	clk,
	rst_n,
	keyin,
	led
	);
	
	input clk;
	input rst_n;
	input keyin;
	
	output reg led;
	
	localparam
		IDLE     = 4'b0_001,
		P_FILTER = 4'b0_010,
		DOWN     = 4'b0_100,
		R_FILTER = 4'b1_000;
		
	parameter CNTMAX = 20'd999_999;//20ms
//	parameter CNTMAX = 20'd9_999;//20ms
	
	reg  [4:0]state;
	reg  [4:0]nx_state;
	reg  keyin_r;
	reg  keyin_tempa;
	reg  keyin_tempb;
	wire pedge;
	wire nedge;
	reg  [19:0]cnt;
	reg  en_cnt;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)begin 
		keyin_tempa <= 1'b1;
		keyin_tempb <= 1'b1;
	end 
	else begin 
		keyin_tempa <= keyin;
		keyin_tempb <= keyin_tempa;
	end 
	
	assign pedge = keyin_tempa & (!keyin_tempb);
	assign nedge = (!keyin_tempa) & keyin_tempb;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)begin 
		cnt <= 20'd0;
	end 
	else if(en_cnt)begin //en_cnt一直为1
		if(cnt==CNTMAX)
			cnt <= 20'd0;
		else 
			cnt <= cnt + 1'b1;
	end 
	else 
		cnt <= 20'd0;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		state <= IDLE;
	else 
		state <= nx_state;
		
	always@(posedge clk or negedge rst_n)
	if(!rst_n)begin 
		keyin_r <= 1'b1;
		en_cnt  <= 1'b0;
	end 
	else begin 
		case(state)
			IDLE:begin 
				keyin_r <= 1'b1;
				if(nedge)begin 
					en_cnt  <= 1'b1;
				end 
				else
					en_cnt <= 1'b0;
			end 
			P_FILTER:begin 
				if(cnt==CNTMAX)begin 
					en_cnt <= 1'b0;
					keyin_r<= 1'b0;
				end 
				else if(pedge)begin 
					en_cnt <= 1'b0;
				end 
				else begin 
					en_cnt <= en_cnt;
					keyin_r<= 1'b1;
				end 
			end 
			DOWN:begin
				keyin_r <= 1'b1;
				if(pedge)begin 
					en_cnt <= 1'b1;
				end 
				else begin
					en_cnt <= en_cnt;
				end 
			end
			R_FILTER:
				if(cnt==CNTMAX)
					en_cnt <= 1'b0;
				else if(nedge)
					en_cnt <= 1'b0;
				else 
					en_cnt <= en_cnt;
		endcase 
	end 
		
	always@(*)begin 
		case(state)
			IDLE:begin 
				if(nedge)
					nx_state = P_FILTER;
				else 
					nx_state = IDLE;
			end 
			P_FILTER:begin 
				if(cnt==CNTMAX)
					nx_state = DOWN;
				else if(pedge)
					nx_state = IDLE;
				else 
					nx_state = P_FILTER;
			end 
			DOWN:begin 
				if(pedge)
					nx_state = R_FILTER;
				else 
					nx_state = DOWN;
			end 
			R_FILTER:begin 
				if(cnt==CNTMAX)
					nx_state = IDLE;
				else if(nedge)
					nx_state = DOWN;
				else 
					nx_state = R_FILTER;
			end 
			default:
				nx_state = IDLE;
		endcase
	end 
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		led <= 1'b1;
	else if(keyin_r==1'b0) 
		led <= led + (~keyin_r);
	else 
		led <= led;
	
endmodule 

-----
//module ledkey_top.v
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
