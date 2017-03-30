module Axis_WR(
						Clk,
						Addr,
						MCUportL,
						Din,
						SpeedSetDone,						
						
						SpeedSet,
						AxisStateCmd,
						AxisPlsCmd,
						SpeedCmd,
						TargetPos,
						RefPos
    );
input				Clk;
input[7:0]		Addr;
input[15:0]		MCUportL;
input[7:0]		Din;

output[15:0]		AxisStateCmd;
output[7:0]		AxisPlsCmd;
output[7:0]		SpeedCmd;
output[15:0]	TargetPos;
output[15:0]	RefPos;
reg[7:0]			AxisPlsCmd,SpeedCmd;
reg[15:0]		AxisStateCmd;
reg[15:0]		RefPos;
reg[15:0]		TargetPos;



input		SpeedSetDone;
output	reg	SpeedSet;
always @(posedge Clk or posedge SpeedSetDone)			//add by tt
	begin
		if(SpeedSetDone)
			SpeedSet <= 1'b0;
		else if(Addr[2:0] == 3'h2)
			SpeedSet <= 1'b1;
	end
//Din: large fan-out. 
/*
assign	AxisStateCmd =((~Clk) & MCUportL[0]) ?Din :8'h00;
assign	AxisPlsCmd =((~Clk) & MCUportL[1]) ?Din :8'h00;
/*
always @(AxisCmd)
	begin
		if(MCUportL[0])
			AxisStateCmd <=AxisCmd;
		if(MCUportL[1])
			AxisPlsCmd <=AxisCmd;
		if(MCUportL[2])
			SpeedCmd <=AxisCmd;
		if(MCUportL[3])
			SpeedFallOut <=AxisCmd;
		if(MCUportL[4])
			TargetPos[7:0] <=AxisCmd;
		if(MCUportL[5])
			TargetPos[15:8] <=AxisCmd;
		if(MCUportL[6])
			RefPos[7:0] <=AxisCmd;
		if(MCUportL[7])
			RefPos[15:8] <=AxisCmd;
	end
*/

always @(posedge Clk)
	begin
		if(MCUportL[0])
			AxisStateCmd[7:0] <=Din;
		if(MCUportL[1])
			AxisPlsCmd <=Din;
		if(MCUportL[2])
			SpeedCmd <=Din;
		if(MCUportL[3])
			AxisStateCmd[15:8] <=Din;
//		if(MCUportL[4])
//			TargetPos[7:0] <=Din;
//		if(MCUportL[5])
//			TargetPos[15:8] <=Din;
		if(MCUportL[6])
			RefPos[7:0] <=Din;
		if(MCUportL[7])
			RefPos[15:8] <=Din;
	end

/*
always @(posedge Clk)
	begin
		case(Addr[2:0])
			3'b000:	
				AxisStateCmd <=Din;				
			3'b001:	
				AxisPlsCmd <=Din;
			3'b010:	
				SpeedCmd <=Din;			//In case of the semi-stable state of the clock division module ,SpeedCmd should be stable before it is added to the sCnt every time it is writen. 
			3'b011:
				SpeedFallOut <=Din;
			3'b100:
				TargetPos[7:0] <=Din;
			3'b101:	
				TargetPos[15:8] <=Din;
			3'b110:
				RefPos[7:0] <=Din;
			3'b111:
				RefPos[15:8] <=Din;
		endcase
	end
*/

endmodule
