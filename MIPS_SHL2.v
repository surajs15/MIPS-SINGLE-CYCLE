`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		Suraj Salian
// 
// Create Date:    19:41:11 02/17/2021 
// Design Name: 
// Module Name:     SHIFT LEFT -2
// Project Name: 

// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
////////////////////////////////////// SHIFT LEFT BY 2 ////////////////////////
module MIPS_SHL2(
	input   [31:0] Data1,
	output	reg [31:0] Out
);

	always @(Data1) //SHIFT LEFT INPUT DATA BY2
	begin
		Out = Data1 << 2;
	end

endmodule
