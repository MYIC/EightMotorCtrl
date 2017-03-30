`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		 XJTU
// Engineer: 		 YangSen
// 
// Create Date:    14:23:25 11/16/2016 
// Design Name:
// Module Name:    EightMotorCtrl_TOP 
// Project Name: 	 EightMotorCtrl
// Target Devices: XC3S200AN
// Tool versions:  ISE14.7
// Description: 	 1.Position ctrl for the step motor; 2.Read and write the IO.
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module EightMotorCtrl_TOP(
			gClk0,
			ALE,
			WR,
			RD,
			AD,
			
			P2_2,					//
			P2_3,					//Unused Pin
			
			Xin,		//8-channal input
			Yout,		//16-channal relay output
			
			StepMotorPara_A,
			StepMotorPara_B,
			StepMotorPara_C,
			StepMotorPara_D,
			StepMotorPara_E,
			StepMotorPara_F,
			StepMotorPara_G,			
			StepMotorPara_H,			
			
			Opt,
			StepMotorFeedBack_A,
			StepMotorFeedBack_B,
			StepMotorFeedBack_C,
			StepMotorFeedBack_D,
			StepMotorFeedBack_E,
			StepMotorFeedBack_F,
			StepMotorFeedBack_G,
			StepMotorFeedBack_H
    );
input			gClk0;
input			ALE,WR,RD;
inout[7:0]	AD;
input			P2_2;
input			P2_3;

input[7:0]	Xin;
output[15:0]Yout;
reg[15:0]	Yout;

output[5:0]	StepMotorPara_A;
output[5:0]	StepMotorPara_B;
output[5:0]	StepMotorPara_C;
output[5:0]	StepMotorPara_D;
output[5:0]	StepMotorPara_E;
output[5:0]	StepMotorPara_F;
output[5:0]	StepMotorPara_G;
output[5:0]	StepMotorPara_H;

input[7:0]	Opt;
input[1:0]	StepMotorFeedBack_A;
input[1:0]	StepMotorFeedBack_B;
input[1:0]	StepMotorFeedBack_C;
input[1:0]	StepMotorFeedBack_D;
input[1:0]	StepMotorFeedBack_E;
input[1:0]	StepMotorFeedBack_F;
input[1:0]	StepMotorFeedBack_G;
input[1:0]	StepMotorFeedBack_H;

wire			gClk1;
IBUFG		IBUFG_inst0(
							.I(gClk0),   // Clock buffer input (connect directly to top-level port)
							.O(gClk1)  	 // Clock buffer output
);
wire 			gClk;
BUFG 		BUFG_inst0(
							.I(gClk1),    // Clock buffer input
							.O(gClk)      // Clock buffer output
);

wire[7:0]	gPlsCmd;
wire			gRst = gPlsCmd[7];
wire			Clk_25M;
wire[3:0]	sClk;
FrequencyDiv 	gClkCtrl(
					.gClk(gClk),
					.Rst(gRst),
					
					.Clk(Clk_25M),
					.Clk_2S(),
					.Clk_4S(sClk)
    );

wire[7:0]	Addr;
wire[15:0]	mCS;
wire[15:0]	MCUportL;
MCU_Interface	MCU51_Interface(
										.ALE(ALE),
										.WR(WR),
										.Din(AD),
					
										.Addr(Addr),
										.CS(mCS),
										.MCUportL(MCUportL)
										);

wire[7:0]		gStateCmd;
wire				PosLock =gPlsCmd[0];
MCU_WR	MCU_WR(
							.CS(mCS[0]),
							.MCUportL(MCUportL),
							.WR(WR),
							.Din(AD),
							
							.gStateCmd(gStateCmd),
							.gPlsCmd(gPlsCmd)							
    );

wire[7:0]			AxisDQ_A,AxisDQ_B,AxisDQ_C,AxisDQ_D,AxisDQ_E,AxisDQ_F,AxisDQ_G,AxisDQ_H;

/*
wire[7:0]			AxisDQ_1 = (P2_2 == 1'b1) ?AxisDQ_A :AxisDQ_E;
wire[7:0]			AxisDQ_2 = (P2_2 == 1'b1) ?AxisDQ_B :AxisDQ_F;
wire[7:0]			AxisDQ_3 = (P2_2 == 1'b1) ?AxisDQ_C :AxisDQ_G;
wire[7:0]			AxisDQ_4 = (P2_2 == 1'b1) ?AxisDQ_D :AxisDQ_H;
*/

RDbus RDBus(
							.CS(CS),
							.Addr(Addr),
							.RD(RD),
							.DQ(AD),
							
							.Xin(Xin),
							.AxisDQ_1(AxisDQ_A),
							.AxisDQ_2(AxisDQ_B),
							.AxisDQ_3(AxisDQ_C),
							.AxisDQ_4(AxisDQ_D),
							.AxisDQ_5(AxisDQ_E),
							.AxisDQ_6(AxisDQ_F),
							.AxisDQ_7(AxisDQ_G),
							.AxisDQ_8(AxisDQ_H)

);

wire		 WR_Out = mCS[2] | WR;
always @(posedge WR_Out)
	begin
		if(MCUportL[0])
			Yout[7:0] <= AD;
		else if(MCUportL[1])
			Yout[15:8] <= AD;
	end

/*
wire[7:0]	mmCS;
assign	mmCS[0] = (P2_2 == 1'b1) ?mCS[4] :1'b1;
assign	mmCS[1] = (P2_2 == 1'b1) ?mCS[6] :1'b1;
assign	mmCS[2] = (P2_2 == 1'b1) ?mCS[8] :1'b1;
assign	mmCS[3] = (P2_2 == 1'b1) ?mCS[10] :1'b1;
assign	mmCS[4] = (P2_2 == 1'b0) ?mCS[4] :1'b1;
assign	mmCS[5] = (P2_2 == 1'b0) ?mCS[6] :1'b1;
assign	mmCS[6] = (P2_2 == 1'b0) ?mCS[8] :1'b1;
assign	mmCS[7] = (P2_2 == 1'b0) ?mCS[10] :1'b1;
*/
Axis_Ctrl_20BitWidth	Axis_Ctrl_A(
    .Clk(Clk_25M),
    .gRst(gRst),
    .Addr(Addr),
    .MCUportL(MCUportL),
    .WR(WR),
    .CS(mCS[3]),
    .Din(AD),
    .PosLock(PosLock),
    .Ref(~Opt[0]),
    .Protect(StepMotorFeedBack_A[1]),
    .MO(StepMotorFeedBack_A[0]),
	 
    .nStanby(StepMotorPara_A[0]),
    .DRVRst(StepMotorPara_A[1]),
    .PlsOut(StepMotorPara_A[5]),
    .Dir(StepMotorPara_A[4]),
	 .Torque1(StepMotorPara_A[2]),
	 .Torque2(StepMotorPara_A[3]),

    .DQtoMCU(AxisDQ_A)
    );

Axis_Ctrl	Axis_Ctrl_B(
    .Clk(Clk_25M),
    .gRst(gRst),
    .Addr(Addr),
    .MCUportL(MCUportL),
    .WR(WR),
    .CS(mCS[4]),
    .Din(AD),
    .PosLock(PosLock),
    .Ref(~Opt[1]),
    .Protect(StepMotorFeedBack_B[1]),
    .MO(StepMotorFeedBack_B[0]),
	 
    .nStanby(StepMotorPara_B[0]),
    .DRVRst(StepMotorPara_B[1]),
    .PlsOut(StepMotorPara_B[5]),
    .Dir(StepMotorPara_B[4]),
	 .Torque1(StepMotorPara_B[2]),
	 .Torque2(StepMotorPara_B[3]),

    .DQtoMCU(AxisDQ_B)
    );

Axis_Ctrl	Axis_Ctrl_C(
    .Clk(Clk_25M),
    .gRst(gRst),
    .Addr(Addr),
    .MCUportL(MCUportL),
    .WR(WR),
    .CS(mCS[5]),
    .Din(AD),
    .PosLock(PosLock),
    .Ref(~Opt[2]),
    .Protect(StepMotorFeedBack_C[1]),
    .MO(StepMotorFeedBack_C[0]),
	 
    .nStanby(StepMotorPara_C[0]),
    .DRVRst(StepMotorPara_C[1]),
    .PlsOut(StepMotorPara_C[5]),
    .Dir(StepMotorPara_C[4]),
	 .Torque1(StepMotorPara_C[2]),
	 .Torque2(StepMotorPara_C[3]),

    .DQtoMCU(AxisDQ_C)
    );

Axis_Ctrl	Axis_Ctrl_D(
    .Clk(Clk_25M),
    .gRst(gRst),
    .Addr(Addr),
    .MCUportL(MCUportL),
    .WR(WR),
    .CS(mCS[6]),
    .Din(AD),
    .PosLock(PosLock),
    .Ref(~Opt[3]),
    .Protect(StepMotorFeedBack_D[1]),
    .MO(StepMotorFeedBack_D[0]),
	 
    .nStanby(StepMotorPara_D[0]),
    .DRVRst(StepMotorPara_D[1]),
    .PlsOut(StepMotorPara_D[5]),
    .Dir(StepMotorPara_D[4]),
	 .Torque1(StepMotorPara_D[2]),
	 .Torque2(StepMotorPara_D[3]),

    .DQtoMCU(AxisDQ_D)
    );

Axis_Ctrl	Axis_Ctrl_E(
    .Clk(Clk_25M),
    .gRst(gRst),
    .Addr(Addr),
    .MCUportL(MCUportL),
    .WR(WR),
    .CS(mCS[7]),
    .Din(AD),
    .PosLock(PosLock),
    .Ref(Opt[4]),
    .Protect(StepMotorFeedBack_E[1]),
    .MO(StepMotorFeedBack_E[0]),
	 
    .nStanby(StepMotorPara_E[0]),
    .DRVRst(StepMotorPara_E[1]),
    .PlsOut(StepMotorPara_E[5]),
    .Dir(StepMotorPara_E[4]),
	 .Torque1(StepMotorPara_E[2]),
	 .Torque2(StepMotorPara_E[3]),

    .DQtoMCU(AxisDQ_E)
    );
	 
Axis_Ctrl	Axis_Ctrl_F(
    .Clk(Clk_25M),
    .gRst(gRst),
    .Addr(Addr),
    .MCUportL(MCUportL),
    .WR(WR),
    .CS(mCS[8]),
    .Din(AD),
    .PosLock(PosLock),
    .Ref(~Opt[5]),
    .Protect(StepMotorFeedBack_F[1]),
    .MO(StepMotorFeedBack_F[0]),
	 
    .nStanby(StepMotorPara_F[0]),
    .DRVRst(StepMotorPara_F[1]),
    .PlsOut(StepMotorPara_F[5]),
    .Dir(StepMotorPara_F[4]),
	 .Torque1(StepMotorPara_F[2]),
	 .Torque2(StepMotorPara_F[3]),

    .DQtoMCU(AxisDQ_F)
    );	

Axis_Ctrl_18BitWidth	Axis_Ctrl_G(
    .Clk(Clk_25M),
    .gRst(gRst),
    .Addr(Addr),
    .MCUportL(MCUportL),
    .WR(WR),
    .CS(mCS[9]),
    .Din(AD),
    .PosLock(PosLock),
    .Ref(~Opt[6]),
    .Protect(StepMotorFeedBack_G[1]),
    .MO(StepMotorFeedBack_G[0]),
	 
    .nStanby(StepMotorPara_G[0]),
    .DRVRst(StepMotorPara_G[1]),
    .PlsOut(StepMotorPara_G[5]),
    .Dir(StepMotorPara_G[4]),
	 .Torque1(StepMotorPara_G[2]),
	 .Torque2(StepMotorPara_G[3]),

    .DQtoMCU(AxisDQ_G)
    );	

Axis_Ctrl	Axis_Ctrl_H(
    .Clk(Clk_25M),
    .gRst(gRst),
    .Addr(Addr),
    .MCUportL(MCUportL),
    .WR(WR),
    .CS(mCS[10]),
    .Din(AD),
    .PosLock(PosLock),
    .Ref(Opt[7]),
    .Protect(StepMotorFeedBack_H[1]),
    .MO(StepMotorFeedBack_H[0]),
	 
    .nStanby(StepMotorPara_H[0]),
    .DRVRst(StepMotorPara_H[1]),
    .PlsOut(StepMotorPara_H[5]),
    .Dir(StepMotorPara_H[4]),
	 .Torque1(StepMotorPara_H[2]),
	 .Torque2(StepMotorPara_H[3]),

    .DQtoMCU(AxisDQ_H)
    );		 

endmodule






















