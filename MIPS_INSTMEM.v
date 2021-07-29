`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		Suraj Salian
// 
// Create Date:    19:41:11 02/17/2021 
// Design Name: 
// Module Name:     INSTRUCTION MEMORY
// Project Name: 

// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
///////////////////////////////////INSTRUCTION MEMORY///////////////////////////
module MIPS_INSTMEM(
	input 	[31:0] PC, // PC INPUT
	output	reg [31:0] INSTRUCTION		//OUTPUT INSTRUCTION
);
	reg [7:0] ROM [127:0];	//byte organized data
	
	//LOADING INSTRUCTION MEMORY FROM "Instruction.mem" File"
	initial begin
		$readmemb("Instruction.mem", ROM);
	end

	always @(PC)
	begin
		INSTRUCTION[31:0] = {ROM[PC+3],ROM[PC+2],ROM[PC+1],ROM[PC]};
	end
endmodule