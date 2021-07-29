`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		Suraj Salian
// 
// Create Date:    19:41:11 02/17/2021 
// Design Name: 
// Module Name:     REGISTER FILE
// Project Name: 

// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
/////////////////////////////////////// PARAMETERIZED MUX/////////////////////////
module MIPS_MUX #(parameter SIZE=32) (
	input   [SIZE-1:0] Input1,
	input   [SIZE-1:0] Input2,	
	input 	ControlSignal,
	output	reg [SIZE-1:0] Output
);
	always @(Input1, Input2, ControlSignal)
	begin
		case(ControlSignal)
			0 : Output <= Input1;
			1 : Output <= Input2;
		endcase
	end

	
endmodule
