module MCU_WR(
							CS,
							MCUportL,
							WR,
							Din,
							
							gStateCmd,
							gPlsCmd							
    );
/*
MCU_WR	MCU_WR(
							.CS(),
							.MCUportL(),
							.WR(),
							.Din(),
							
							.gStateCmd(),
							.gPlsCmd()							
    );
*/
input				CS;
input[15:0]		MCUportL;
input				WR;
input[7:0]		Din;

output	reg[7:0] gStateCmd;
output[7:0]  		gPlsCmd;

wire 		WR_GBL;
assign	WR_GBL = WR|CS;
always @(posedge WR_GBL)
	begin
		if(MCUportL[1])
			gStateCmd <=Din;
	end

assign	gPlsCmd =(MCUportL[0] ==1'b1 && WR_GBL ==1'b0)? Din:8'h0;	//PLSCMD脉宽为1个nWR有效期

endmodule
