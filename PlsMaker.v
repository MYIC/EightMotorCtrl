module PlsMaker(
					Clk,
					gRst,
//					DirCmd,
					SpeedCmd,			//fsys/2^(n+1)*SpeedCmd <= fstepmax;  fstepmax = 200kHz
			
					SpeedSet,
//					RefClr,
//					PlsClr,
//					Ref,
//					RefPos,
//					RefEn,
					
					SpeedSetDone,					
					Pls_Out
//					PlsCnt,				
//					RefDone
);
input			Clk;
input			gRst;
//input			DirCmd;
input[7:0]	SpeedCmd;
//input[15:0]	RefPos;
input			SpeedSet;

//input			RefClr;
//input			PlsClr;
//input			Ref,RefEn;


output	reg	SpeedSetDone;
output	reg	Pls_Out;
//output	reg[15:0]	PlsCnt;
//output	reg	RefDone;

reg	SpeedSetEn;
always @(posedge Clk)
	begin
		SpeedSetEn <=SpeedSet;
		SpeedSetDone <=SpeedSetEn;
	end
reg[7:0]		SpeedCur;
always @(posedge SpeedSetEn)
	begin
		SpeedCur <=SpeedCmd;
	end

reg		sCntClr;
always @(posedge Clk)
	begin
		if(SpeedCur ==8'h0)
			sCntClr <= 1'b1;
		else
			sCntClr <= 1'b0;
	end

reg[16:0]	sCnt;
always @(posedge Clk or posedge sCntClr)
	begin
		if(sCntClr)
			sCnt <=17'h0;
		else
			sCnt <= sCnt + SpeedCur;
	end

always @(posedge Clk)
	begin
		Pls_Out <= sCnt[16];
	end	

/*
reg		Ref0;
reg		Ref1;
reg		Refpls;
always @(posedge Clk)
	begin
		Ref0 <= Ref;
		Ref1 <= Ref0;
	end

wire Ref_En = (~RefDone)&RefEn;

always @(posedge Clk)
	begin
		if(Ref_En)
			Refpls <= (~Ref0) & Ref1;
		else
			Refpls <= 1'b0;
	end
	
wire	RefDoneClr =gRst | RefClr;
always @(posedge RefDoneClr or posedge Refpls)
	begin
		if(RefDoneClr)
			RefDone <= 1'b0;
		else
			RefDone <= 1'b1;
	end

wire PlsCntClr = PlsClr | gRst | Refpls;
always @(posedge Pls_Out or posedge PlsCntClr)
	begin
		if (PlsCntClr)
			PlsCnt <= 16'h0;			
		else if(DirCmd)
			PlsCnt <= PlsCnt + 1'b1;
		else
			PlsCnt <= PlsCnt - 1'b1;
	end
*/

endmodule





