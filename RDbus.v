module RDbus(
							CS,
							Addr,
							RD,
							DQ,
							
							Xin,
							AxisDQ_1,
							AxisDQ_2,
							AxisDQ_3,
							AxisDQ_4,
							AxisDQ_5,
							AxisDQ_6,
							AxisDQ_7,
							AxisDQ_8

    );
/*
RDbus RDBus(
							.CS(),
							.Addr(),
							.RD(),
							.DQ(),
							
							.Xin(),
							.AxisDQ_1(),
							.AxisDQ_2(),
							.AxisDQ_3(),
							.AxisDQ_4(),
							.AxisDQ_5(),
							.AxisDQ_6(),
							.AxisDQ_7(),
							.AxisDQ_8()

    );
*/
input[15:0]		CS;
input[7:0]		Addr;
input				RD;
input[7:0]		Xin;
input[7:0]		AxisDQ_1,AxisDQ_2,AxisDQ_3,AxisDQ_4,AxisDQ_5,AxisDQ_6,AxisDQ_7,AxisDQ_8;

output[7:0]		DQ;
reg[7:0]			DQq;

assign DQ =(RD ==1'b0) ?DQq :8'hzz;

always @(negedge RD)
	begin
		case (Addr[7:4])
			4'h1: DQq <= Xin;
//			4'h1: DQq <= 8'haa;
		   4'h3: DQq <= AxisDQ_1;
			4'h4: DQq <= AxisDQ_2;
			4'h5: DQq <= AxisDQ_3;
			4'h6: DQq <= AxisDQ_4;
			4'h7: DQq <= AxisDQ_5;
			4'h8: DQq <= AxisDQ_6;
			4'h9: DQq <= AxisDQ_7;
			4'ha: DQq <= AxisDQ_8;
			default: DQq <= 8'h00;
		endcase
	end

endmodule

