module FrequencyDiv(
					gClk,
					Rst,
					
					Clk,
					Clk_2S,
					Clk_4S
    );
/*
FrequencyDiv 	gClkCtrl(
					.gClk(),
					.Rst(),
					
					.Clk(),
					.Clk_2S(),
					.Clk_4S()
    );
*/
input				gClk;
input				Rst;
output			Clk;
output[1:0]		Clk_2S;
output[3:0]		Clk_4S;

reg[1:0]			Clk_2S;
reg[3:0]			Clk_4S;
reg[1:0]			Cnt_time;
reg[2:0]			Cnt;
wire[7:0]		pls_8s;
assign	pls_8s[0] = (Cnt == 3'h0) ? 1'b1 : 1'b0;
assign	pls_8s[1] = (Cnt == 3'h1) ? 1'b1 : 1'b0;
assign	pls_8s[2] = (Cnt == 3'h2) ? 1'b1 : 1'b0;
assign	pls_8s[3] = (Cnt == 3'h3) ? 1'b1 : 1'b0;
assign	pls_8s[4] = (Cnt == 3'h4) ? 1'b1 : 1'b0;
assign	pls_8s[5] = (Cnt == 3'h5) ? 1'b1 : 1'b0;
assign	pls_8s[6] = (Cnt == 3'h6) ? 1'b1 : 1'b0;
assign	pls_8s[7] = (Cnt == 3'h7) ? 1'b1 : 1'b0;

always@ (posedge gClk or posedge Rst)
	begin
		if(Rst)
			Cnt_time <= 2'h0;
		else
			Cnt_time <= Cnt_time + 1'b1;
	end
assign	Clk = Cnt_time[1];

always@	(posedge gClk or posedge Rst)
	begin
		if(Rst)
			Cnt <= 3'h0;
		else if(pls_8s[7])
			Cnt <= 3'h0;
		else
			Cnt <= Cnt + 1'b1;
	end

always@	(posedge gClk)
	begin
		if(pls_8s[1])
			Clk_2S[0] <= 1'b1;
		else if(pls_8s[3])
			Clk_2S[0] <= 1'b0;
	end

always@	(posedge gClk)
	begin
		if(pls_8s[5])
			Clk_2S[1] <= 1'b1;
		else if(pls_8s[7])
			Clk_2S[1] <= 1'b0;
	end

always@	(posedge gClk)
	begin
		if(pls_8s[0])
			Clk_4S[0] <= 1'b1;
		else if(pls_8s[1])
			Clk_4S[0] <= 1'b0;
	end
	
always@	(posedge gClk)
	begin
		if(pls_8s[1])
			Clk_4S[1] <= 1'b1;
		else if(pls_8s[2])
			Clk_4S[1] <= 1'b0;
	end
	
always@	(posedge gClk)
	begin
		if(pls_8s[2])
			Clk_4S[2] <= 1'b1;
		else if(pls_8s[3])
			Clk_4S[2] <= 1'b0;
	end

always@	(posedge gClk)
	begin
		if(pls_8s[3])
			Clk_4S[3] <= 1'b1;
		else if(pls_8s[4])
			Clk_4S[3] <= 1'b0;
	end	
endmodule
