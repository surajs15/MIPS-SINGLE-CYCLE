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
//
/////////////////////////////////////////// JUMP SHIFT LEFT///////////////////////////
//USED FOR JUMP INSTRUCTION
module MIPS_PCSLL(
	input   [25:0] Data1,
	input	[31:0] PCsum,
	output	reg [31:0] Out
);

	always @(PCsum,Data1 )
	begin
		Out[31:0]  = {PCsum[31:28] , Data1[25:0],2'b0};
	end


endmodule
