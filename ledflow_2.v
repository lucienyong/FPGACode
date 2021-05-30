module ledflow(clk,rst_n,led);

	input clk;//T21
	input rst_n;//B19
	
	output reg[3:0]led;//E12,C15,G13,D15
	
	reg [27:0]cnt;
	
	localparam T500MS  = 28'd24_999_999;
	localparam T1000MS = 28'd49_999_999;
	
//	localparam T500MS  = 28'd4_999;
//	localparam T1000MS = 28'd9_999;
	
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		cnt <= 28'd0;
	else if(cnt==T500MS)
		cnt <= 28'd0;
	else 
		cnt <= cnt + 1'b1;
		
	always@(posedge clk or negedge rst_n)
	if(!rst_n)
		led <= 4'b1110;
	else if(cnt==T500MS)
		led <= {led[2:0],led[3]};
	else 
		led <= led;
		
endmodule 
