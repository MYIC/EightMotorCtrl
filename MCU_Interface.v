module 	MCU_Interface(
					ALE,
					WR,
					Din,
					
					Addr,
					CS,
					MCUportL
    );
/*
MCU_Interface	MCU51_Interface(
										.ALE(),
										.WR(),
										.Din(),
					
										.Addr(),
										.CS(),
										.MCUportL()
										);
*/
input			ALE;
input			WR;
input[7:0]		Din;

output[7:0]		Addr;
output[15:0]	CS;
output[15:0]	MCUportL;
reg[7:0]			Addr;

assign CS[0] = (Addr[7:4] == 4'h0) ? 1'b0 : 1'b1;
assign CS[1] = (Addr[7:4] == 4'h1) ? 1'b0 : 1'b1;
assign CS[2] = (Addr[7:4] == 4'h2) ? 1'b0 : 1'b1;
assign CS[3] = (Addr[7:4] == 4'h3) ? 1'b0 : 1'b1;
assign CS[4] = (Addr[7:4] == 4'h4) ? 1'b0 : 1'b1;
assign CS[5] = (Addr[7:4] == 4'h5) ? 1'b0 : 1'b1;
assign CS[6] = (Addr[7:4] == 4'h6) ? 1'b0 : 1'b1;
assign CS[7] = (Addr[7:4] == 4'h7) ? 1'b0 : 1'b1;
assign CS[8] = (Addr[7:4] == 4'h8) ? 1'b0 : 1'b1;
assign CS[9] = (Addr[7:4] == 4'h9) ? 1'b0 : 1'b1;
assign CS[10] = (Addr[7:4] == 4'ha) ? 1'b0 : 1'b1;
assign CS[11] = (Addr[7:4] == 4'hb) ? 1'b0 : 1'b1;
assign CS[12] = (Addr[7:4] == 4'hc) ? 1'b0 : 1'b1;
assign CS[13] = (Addr[7:4] == 4'hd) ? 1'b0 : 1'b1;
assign CS[14] = (Addr[7:4] == 4'he) ? 1'b0 : 1'b1;
assign CS[15] = (Addr[7:4] == 4'hf) ? 1'b0 : 1'b1;

always @(negedge ALE)			//flip-flop
	begin
		Addr <= Din;
	end

/*
always @(ALE or Din)				//latch
	begin
		if(ALE == 1'b1)
			Addr <= Din;
	end
*/

assign MCUportL[0]  =  ~Addr[3] & ~Addr[2] & ~Addr[1] & ~Addr[0];
assign MCUportL[1]  =  ~Addr[3] & ~Addr[2] & ~Addr[1] &  Addr[0];
assign MCUportL[2]  =  ~Addr[3] & ~Addr[2] &  Addr[1] & ~Addr[0];
assign MCUportL[3]  =  ~Addr[3] & ~Addr[2] &  Addr[1] &  Addr[0];
assign MCUportL[4]  =  ~Addr[3] &  Addr[2] & ~Addr[1] & ~Addr[0];
assign MCUportL[5]  =  ~Addr[3] &  Addr[2] & ~Addr[1] &  Addr[0];
assign MCUportL[6]  =  ~Addr[3] &  Addr[2] &  Addr[1] & ~Addr[0];
assign MCUportL[7]  =  ~Addr[3] &  Addr[2] &  Addr[1] &  Addr[0];
assign MCUportL[8]  =   Addr[3] & ~Addr[2] & ~Addr[1] & ~Addr[0];
assign MCUportL[9]  =   Addr[3] & ~Addr[2] & ~Addr[1] &  Addr[0];
assign MCUportL[10] =   Addr[3] & ~Addr[2] &  Addr[1] & ~Addr[0];
assign MCUportL[11] =   Addr[3] & ~Addr[2] &  Addr[1] &  Addr[0];
assign MCUportL[12] =   Addr[3] &  Addr[2] & ~Addr[1] & ~Addr[0];
assign MCUportL[13] =   Addr[3] &  Addr[2] & ~Addr[1] &  Addr[0];
assign MCUportL[14] =   Addr[3] &  Addr[2] &  Addr[1] & ~Addr[0];
assign MCUportL[15] =   Addr[3] &  Addr[2] &  Addr[1] &  Addr[0];


endmodule



