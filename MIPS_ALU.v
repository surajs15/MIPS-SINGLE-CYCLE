`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		Suraj Salian
// 
// Create Date:    19:41:11 02/17/2021 
// Design Name: 
// Module Name:     ALU
// Project Name: 

// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//SET OF INSTRUCTIONS PERFORMED BY ALU
`define AND 	4'b0001
`define ADD 	4'b0010
`define OR  	4'b0011
`define LUI 	4'b0101
`define SUB 	4'b0110
`define SLT 	4'b0111
`define SLL 	4'b1000
`define SRL 	4'b1001
`define FPNEG	4'b1010
`define FPSUB	4'b1011
`define NOR 	4'b1100
`define XOR	4'b1110
`define FPADD	4'b1111

//////////////////////////////////////ARITHMETIC LOGIC UNIT///////////////////////////////////////
module MIPS_ALU(
	input   [31:0] ReadData1,
	input   [31:0] ReadData2,	
	input 	[3:0] ALUOP,
	input   [4:0] SHAMT,
	output	reg [31:0] ALUResult,
	output	reg  ZERO
);
	wire [31:0] NegReadData2;
	wire [31:0] RESFPADD, RESFPSUB;
	assign NegReadData2 = {(~ReadData2[31]),ReadData2[30:0]};
	
	FLOAT_ADD add0 (ReadData1, ReadData2, RESFPADD); 	// Moduel for Floating Point Additon
	FLOAT_ADD sub0 (ReadData1, NegReadData2, RESFPSUB);	//Module for Floating Point subtraction

	
	
	always @(ReadData1, ReadData2,ALUOP,SHAMT,RESFPADD,RESFPSUB, NegReadData2)
	begin
		
		case(ALUOP)
			`AND: ALUResult = ReadData1 & ReadData2;  		        //AND OPERATION
			`OR:  ALUResult = ReadData1 | ReadData2; 		       //OR OPERATION
			`ADD: ALUResult = ReadData1 + ReadData2;  		      //ADD OPERATION
			`LUI: begin
			      	ALUResult[31:16] = ReadData2[15:0]; 		     // LOAD UPPER IMMEDIATE
				ALUResult[15:0] = 16'b0;
			      end 
			`SUB: ALUResult = ReadData1 - ReadData2; 		    // SUB OPERATION
			`SLT: ALUResult = $signed(ReadData1) < $signed(ReadData2);  // SET IF LESS THAN
			`SLL: ALUResult = ReadData2 << SHAMT;			    //SHIFT LEFT LOGICAL
			`SRL: ALUResult = ReadData2 >> SHAMT; 			   //SHIFT RIGHT LOGICAL
			`NOR: ALUResult = ~(ReadData1 | ReadData2);		  //NOR OPERATION
			`XOR: ALUResult = ReadData1 ^ ReadData2;		  //EXOR OPERATION
			`FPADD:  ALUResult = RESFPADD;				 //FLOATING POINT ADDITION (SINGLE PRECISION)
			`FPSUB:  ALUResult = RESFPSUB;				 //FLOATING POINT SUBTRACTION (SINGLE PRECISION)
			`FPNEG: ALUResult = NegReadData2;			 //FLOATING POINT ADDNEGATION(SINGLE PRECISION)
			
		endcase
		//OUTPUT ZERO SIGNLA IS SET IF ALU RESULT == 0
		ZERO = (ALUResult == 32'b0);
	end
	
	
	

endmodule
