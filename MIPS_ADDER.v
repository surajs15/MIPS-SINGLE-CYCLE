`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		Suraj Salian
// 
// Create Date:    19:41:11 02/17/2021 
// Design Name: 
// Module Name:     MIPS_ADDER
// Project Name: 

// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
module MIPS_ADDER(
	input   [31:0] Data1,
	input   [31:0] Data2,	
	output	reg [31:0] Result
);
//MIPS Adder Module used for Incrementing PC, and Calculating the branch address
	always @(Data1, Data2)
	begin
		Result = Data1 + Data2;
	end

endmodule
