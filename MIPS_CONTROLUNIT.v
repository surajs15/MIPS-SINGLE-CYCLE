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
//

//////////////////////////////////// function FIELD FOR RESPECTIVE INSTRUCTIONS/////////////////////////////////////////
`define ADD 	6'b100000
`define AND 	6'b100100
`define JR 	6'b001000
`define NOR 	6'b100111
`define OR 	6'b100101
`define SLL 	6'b000000
`define SRL 	6'b000010
`define SUB 	6'b100010
`define SLT 	6'b101010
`define XOR 	6'b100110
`define NOP 	6'b000000




//////////////////////////////////////CONTROL UNIT/////////////////////////////////////////////////////////////////
module MIPS_CONTROLUNIT(
	input   [5:0] Opcode,		// OPCODE FIELD INPUT
	input   [4:0] Precision,	// Precision FIELD INPUT
	input   [5:0] Funct,		//FUNCTION FIELD INPUT
	output	reg Memread,		// MEMRORY READ CONTROL SIGNAL
	output	reg Memwrite,		//MEMOR WYRITE CONTROL SIGNAL
	output	reg Memtoreg,		//MEMORY TO REG CONTROL SIGNAL
	output	reg RegWrite,		//REGISTER WRITE CONTROL SIGNAL
	output	reg RegDst,		//REGISTER DESTINATION CONTROL SIGNAL
	output	reg ALUsrc,		// ALU SOURCE CONTROL SIGNAL
	output	reg Branch,		//BRANCH CONTROL SIGNAL
	output	reg Jump,		// JUMP CONTROL SIGNAL
	output	reg Jal,		// JUMP AND LINK CONTROL SIGNAL
	output	reg Jr,			// JUMP REGISTER CONTROL SIGNAL
	output  reg FPinst,		//CONTROL  SIGNAL INDICATING FP
	output	reg [3:0] ALUOP		//ALU OPERATION SIGNAL
);
	always @(Opcode, Funct)
	begin
		Memread = 1'b0;
		Memwrite = 1'b0;
		Memtoreg = 1'b0;
		RegWrite = 1'b0;
		RegDst = 1'b0;
		ALUsrc = 1'b0;
		Branch = 1'b0;
		Jump = 1'b0;
		Jal = 1'b0;
		Jr = 1'b0;
		FPinst = 1'b0;
		ALUOP = 4'b0000;
		
		// R-TYPE INSTRUCTIONS
		if(Opcode == 6'b0)
		begin
			//DEFAULT CONTROL SIGNALS FOR R-TYPE INSTRUCTIONS
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b1;
			RegDst = 1'b1;
			ALUsrc = 1'b0;
			Branch = 1'b0;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b0;
			//ALU OP FOR FUNCTION FIELD
			case(Funct)
				`AND:	ALUOP = 4'b0001;	// AND OPERATION
				`OR:	ALUOP = 4'b0011;	//OR OPERATION
				`ADD:	ALUOP = 4'b0010;	//ADD OPERATION
				`SUB:	ALUOP = 4'b0110;	//SUB OPERATION
				`SLT:	ALUOP = 4'b0111;	//SLT OPERATION
				`SLL:	ALUOP = 4'b1000;	//SLL OPERATION
				`SRL:	ALUOP = 4'b1001;	//SRL OPERATION
				`NOR:	ALUOP = 4'b1100;	//NOR OPERATION
				`XOR:	ALUOP = 4'b1110;	//XOR OPERATION
				//JUMP REGISTER INSTRUCTION
				`JR:	begin
					Memread = 1'b0;
					Memwrite = 1'b0;
					Memtoreg = 1'b0;
					RegWrite = 1'b0;
					RegDst = 1'b0;
					ALUsrc = 1'b0;
					Branch = 1'b0;
					Jump = 1'b0;
					Jal = 1'b0;
					Jr = 1'b1;
					FPinst = 1'b0;
					ALUOP = 4'b0000;
					end
				//NOP OPERATION -> SETTING ALL CONTROL SIGNALS TO 0
				`NOP: begin
					Memread = 1'b0;
					Memwrite = 1'b0;
					Memtoreg = 1'b0;
					RegWrite = 1'b0;
					RegDst = 1'b0;
					ALUsrc = 1'b0;
					Branch = 1'b0;
					Jump = 1'b0;
					Jal = 1'b0;
					Jr = 1'b0;
					FPinst = 1'b0;
					ALUOP = 4'b0000;
				      end
			endcase
		end
		
		//JUMP INSTRUCTION
		else if(Opcode == 6'b000010)
		begin
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b0;
			RegDst = 1'b0;
			ALUsrc = 1'b0;
			Branch = 1'b0;
			Jump = 1'b1;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b0;
			ALUOP = 4'b0000;
		end
		
		// JAL - JUMP AND LINK INSTR
		else if(Opcode == 6'b000011)
		begin
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b0;
			RegDst = 1'b0;
			ALUsrc = 1'b0;
			Branch = 1'b0;
			Jump = 1'b1;
			Jal = 1'b1;
			Jr = 1'b0;
			FPinst = 1'b0;
			ALUOP = 4'b0000;
		end
		

		// ADD IMMEDIATE INSTRUCTION
		else if(Opcode == 6'b001000)
		begin
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b1;
			RegDst = 1'b0;
			ALUsrc = 1'b1;
			Branch = 1'b0;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b0;
			ALUOP = 4'b0010;
		end

		// AND IMMEDIATE INSTRUCTION
		else if(Opcode == 6'b001100)
		begin
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b1;
			RegDst = 1'b0;
			ALUsrc = 1'b1;
			Branch = 1'b0;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b0;
			ALUOP = 4'b0001;
		end

		// BRANCH IF EQUAL INSTRUCTION
		else if(Opcode == 6'b000100)
		begin
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b0;
			RegDst = 1'b0;
			ALUsrc = 1'b0;
			Branch = 1'b1;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b0;
			ALUOP = 4'b0110;
		end

		// LOAD UPPER IMMEDIATE INSTRUCTION		
		else if (Opcode == 6'b001111) 
		begin
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b1;
			RegDst = 1'b0;
			ALUsrc = 1'b1;
			Branch = 1'b0;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b0;
			ALUOP = 4'b0101;
		end
		
		// LOAD WORD INSTRUCTION
		else if (Opcode == 6'b100011) 
		begin
			Memread = 1'b1;
			Memwrite = 1'b0;
			Memtoreg = 1'b1;
			RegWrite = 1'b1;
			RegDst = 1'b0;
			ALUsrc = 1'b1;
			Branch = 1'b0;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b0;
			ALUOP = 4'b0010;
		end
		
		// OR IMMEDIATE INSTRUCTION
		else if (Opcode == 6'b001101) 
		begin
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b1;
			RegDst = 1'b0;
			ALUsrc = 1'b1;
			Branch = 1'b0;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b0;
			ALUOP = 4'b0011;
		end

		// XOR IMMEDIATE INSTRUCTION
		else if (Opcode == 6'b001110) 
		begin
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b1;
			RegDst = 1'b0;
			ALUsrc = 1'b1;
			Branch = 1'b0;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b0;
			ALUOP = 4'b1110;
		end
		
		// SET LESS THAN IMMEDIATE INSTRUCTION
		else if (Opcode == 6'b001010) 
		begin
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b1;
			RegDst = 1'b0;
			ALUsrc = 1'b1;
			Branch = 1'b0;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b0;
			ALUOP = 4'b0111;
		end
		
		// STORE WORD INSTRUCTION
		else if (Opcode == 6'b101011) 
		begin
			Memread = 1'b0;
			Memwrite = 1'b1;
			Memtoreg = 1'b0;
			RegWrite = 1'b0;
			RegDst = 1'b0;
			ALUsrc = 1'b1;
			Branch = 1'b0;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b0;
			ALUOP = 4'b0010;
		end

		// FLOAT ADD
		else if ((Opcode == 6'b010001) && (Funct ==6'b0)) 
		begin
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b1;
			RegDst = 1'b0;
			ALUsrc = 1'b0;
			Branch = 1'b0;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b1;
			ALUOP = 4'b1111;
		end

		// FLOAT SUB
		else if ((Opcode == 6'b010001) && (Funct ==6'b1)) 
		begin
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b1;
			RegDst = 1'b0;
			ALUsrc = 1'b0;
			Branch = 1'b0;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b1;
			ALUOP = 4'b1011;
		end

		//NEgate Float
		else if ((Opcode == 6'b010001) && (Funct ==6'h7)) 
		begin
			Memread = 1'b0;
			Memwrite = 1'b0;
			Memtoreg = 1'b0;
			RegWrite = 1'b1;
			RegDst = 1'b0;
			ALUsrc = 1'b0;
			Branch = 1'b0;
			Jump = 1'b0;
			Jal = 1'b0;
			Jr = 1'b0;
			FPinst = 1'b1;
			ALUOP = 4'b1010;
		end


	end
	
endmodule
