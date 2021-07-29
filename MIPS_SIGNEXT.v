`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		Suraj Salian
// 
// Create Date:    19:41:11 02/17/2021 
// Design Name: 
// Module Name:     SIGN EXTEND
// Project Name: 

// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
////////////////////////////////////////// SIGN EXTEND MODULE//////////////////////
module MIPS_SIGNEXT(
	input   [15:0] Data1,
	output	reg [31:0] Out
);

	always @(Data1)	// SIGN EXTENSION OPERATION
	begin
		if(Data1[15] == 1)
		begin
			Out[31:0] = {16'hFFFF,Data1[15:0]};
		end
		else	
		begin
			Out[31:0] = {16'h0,Data1[15:0]};
		end
	end
	

endmodule
