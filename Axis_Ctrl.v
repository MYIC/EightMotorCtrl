module Axis_Ctrl(
    Clk,
    gRst,
    Addr,
    MCUportL,
    WR,
    CS,
    Din,
    PosLock,
    Ref,
    Protect,
    MO,
	 
    nStanby,
    DRVRst,
    PlsOut,
    Dir,
	 Torque1,
	 Torque2,

    DQtoMCU
    );

/*
Axis_Ctrl	Axis_Ctrl(
    .Clk(),
    .gRst(),
    .Addr(),
    .MCUportL(),
    .WR(),
    .CS(),
    .Din(),
    .PosLock(),
    .Ref(),
    .Protect(),
    .MO(),
	 
    .nStanby(),
    .DRVRst(),
    .PlsOut(),
    .Dir(),

    .DQtoMCU()
    );
*/

input				Clk;
input				gRst;
input[7:0]		Addr;
input[15:0]		MCUportL;
input				WR;
input				CS;
input[7:0]		Din;
input				PosLock;
input				Ref;
input				Protect;
input				MO;

output			nStanby;
output			DRVRst;
output			PlsOut;
output			Dir;
output			Torque1,Torque2;
output[7:0]		DQtoMCU;

wire[15:0]		AxisStateCmd;
wire[7:0]		AxisPlsCmd;
wire[7:0]		SpeedCmd;
wire[15:0]		RefPos;

assign	Torque1 =AxisStateCmd[0];
assign	Torque2 =AxisStateCmd[1];
assign	DirRev =AxisStateCmd[2];
assign	DirCmd =AxisStateCmd[3];
wire		Dir =((~DirCmd) & DirRev)|((DirCmd) & (~DirRev));	//xor ,高电平有效
assign	nStanby =AxisStateCmd[4];									//关闭芯片省电模式
assign	DRVRst =AxisStateCmd[5];									//关闭芯片复位
assign	RefEn_MCU = AxisStateCmd[8];

assign	PlsClr =AxisPlsCmd[0];
assign	StepPls =AxisPlsCmd[1];
assign	RefClr =AxisPlsCmd[2];

wire			SpeedSet;
wire			SpeedSetDone;
wire			WR_CS =WR|CS;
Axis_WR	Axis_WR(
						.Clk(WR_CS),
						.Addr(Addr),
						.MCUportL(MCUportL),
						.Din(Din),
						.SpeedSetDone(SpeedSetDone),						

						.SpeedSet(SpeedSet),
						.AxisStateCmd(AxisStateCmd),
						.AxisPlsCmd(AxisPlsCmd),
						.SpeedCmd(SpeedCmd),
						.RefPos(RefPos)
						);

reg[15:0]	PlsCnt;
reg			RefDone;
wire[7:0]	AxisState = {4'h0,Ref,RefDone,Protect,MO};	

wire				Continuepls;
assign			PlsOut = StepPls|Continuepls;
Axis_RD		Axis_RD(
                  .PClk(Continuepls),
						.Addr(Addr),
						.PosLock(PosLock),
						.PlsCnt(PlsCnt),
						.Axis(AxisState),
						.Din(Din),
						
						.DQ(DQtoMCU)			
						);
						
PlsMaker	PlsMaker(
					.Clk(Clk),
					.gRst(gRst),
//					.DirCmd(DirCmd),
					.SpeedCmd(SpeedCmd),
					.SpeedSet(SpeedSet),
					.SpeedSetDone(SpeedSetDone),
//					.RefClr(RefClr),
//					.PlsClr(PlsClr),
//					.Ref(Ref),
//					.RefPos(RefPos),
//					.RefEn(RefEn_MCU),
					
					.Pls_Out(Continuepls)
//					.PlsCnt(PlsCnt),				
//					.RefDone(RefDone)			
					);

reg		Ref0;
reg		Ref1;
reg		Refpls;
always @(posedge Clk)
	begin
		Ref0 <= Ref;
		Ref1 <= Ref0;
	end

wire RefEn = (~RefDone) & RefEn_MCU;

always @(posedge Clk)
	begin
		if(RefEn)
			Refpls <= (~Ref0) & Ref1;
		else
			Refpls <= 1'b0;
	end
	
wire	RefDoneClr = gRst | RefClr;
always @(posedge RefDoneClr or posedge Refpls)
	begin
		if(RefDoneClr)
			RefDone <= 1'b0;
		else
			RefDone <= 1'b1;
	end

wire PlsCntClr = PlsClr | gRst | Refpls;
always @(posedge Continuepls or posedge PlsCntClr)
	begin
		if(PlsCntClr)
			PlsCnt <= 16'h0;			
		else if(DirCmd)
			PlsCnt <= PlsCnt + 1'b1;
		else
			PlsCnt <= PlsCnt - 1'b1;
	end


endmodule



