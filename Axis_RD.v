module Axis_RD(
						Addr,
						PClk,
						PosLock,
						PlsCnt,
						Axis,
						Din,
						
						DQ		
				
    );
input[7:0]		Addr;
input				PClk;
input				PosLock;
input[15:0]		PlsCnt;
input[7:0]		Axis;
input[7:0]		Din;

output[7:0]			DQ;
wire[7:0]			DQ_0;
reg[15:0]		TxPlsCnt;

always @(posedge PosLock)
	begin
		TxPlsCnt <=PlsCnt;
	end

/*
reg	Lock_Set,Lock_Done,Lock_En;
always @(posedge PClk or posedge Lock_Done)
	begin
		if(Lock_Done)
			Lock_Set <=1'b0;
		else if(PosLock)
			Lock_Set <=1'b1;
	end
always @(posedge PClk)
	begin
		Lock_En <=Lock_Set;
		Lock_Done <= Lock_En;
	end
always @(posedge Lock_En)
	begin
		TxPlsCnt <=PlsCnt;
	end
*/
assign DQ_0 = (Addr[0] == 1'b1) ? TxPlsCnt[15:8] : TxPlsCnt[7:0];
//assign DQ_0 = (Addr[0] == 1'b1) ? 8'h12 : 8'h34;
assign DQ = (Addr[1] == 1'b1) ? Axis :  DQ_0;



endmodule


