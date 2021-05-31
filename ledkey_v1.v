module ledkey(
	clk,
	rst_n,
	keyin,
	led
	);
	
	input clk;
	input rst_n;
	input [3:0]keyin;
	
	output reg[3:0]led;
	
	localparam
		IDLE     = 4'b0_001,
		P_FILTER = 4'b0_010,
		DOWN     = 4'b0_100,
		R_FILTER = 4'b1_000;
		
//	parameter CNTMAX = 20'd999_999;//20ms
	parameter CNTMAX = 20'd9_999;//20ms
	
	reg  [4:0]state;
	reg  [4:0]nx_state;
	reg  [3:0]keyin_r;
	reg  [3:0]keyin_tempa;
	reg  [3:0]keyin_tempb;
	wire [3:0]pedge;
	wire [3:0]nedge;
	reg [19:0]cnt;
	reg en_cnt;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)begin 
		keyin_tempa <= 4'b0000;
		keyin_tempb <= 4'b0000;
	end 
	else begin 
		keyin_tempa <= keyin;
		keyin_tempb <= keyin_tempa;
	end 
	
	assign pedge = keyin_tempa && (!keyin_tempb);
	assign nedge = (!keyin_tempa) && keyin_tempb;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		cnt <= 20'd0;
	else if(en_cnt)begin 
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
		keyin_r <= 4'b1111;
		en_cnt  <= 1'b0;
	end 
	else begin 
		case(state)
			IDLE:begin 
				if(nedge)begin 
					en_cnt <= 1'b1;
				end 
			end 
			P_FILTER:begin 
				if(CNTMAX)begin 
					en_cnt <= 1'b0;
					keyin_r<= keyin_tempb;
				end 
				else if(pedge)
					en_cnt <= 1'b0;
				else 
					en_cnt <= en_cnt;
			end 
			DOWN:begin
				if(pedge)
					en_cnt <= 1'b1;
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
		led <= 4'b1111;
	else begin 
		led[0] <= (~keyin_r[0])?(~led[0]):led[0];
		led[1] <= (~keyin_r[1])?(~led[1]):led[1];
		led[2] <= (~keyin_r[2])?(~led[2]):led[2];
		led[3] <= (~keyin_r[3])?(~led[3]):led[3];
	end 
	
endmodule 
