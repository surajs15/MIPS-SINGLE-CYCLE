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



module MIPS_CORE(
	input   GlobalClock,
	input   GlobalReset	
);
	wire [31:0] PCout;				//PCOUT FROM PC MODULE
	wire [31:0] Instruction;			//32 BIT INTSTR FORM INSTRUCTION MEMORY
	wire [31:0] ReadData1,ReadData2, WriteData;	// READ & WRITE DATA FROM REGISTER FILE
	wire [31:0] MemreadData;			// DATA READ FROM MEMORY
	wire [4:0] WriteReg;				//# OF WRITE REGISTER
	wire [4:0] ReadReg1,ReadReg2;			// # OF READ REGISTERS
	wire [4:0] Shamt;				//SHIFT AMOUNT IN THE ISNTRUCTION FIELD
	wire [4:0] DestReg;				
	wire [5:0] Funct;				//FUNCTION FIELD FROM DECODED INSTRUCTION
	wire [15:0] Immfield;				// IMMEDIATE FIELD FROM DECODED INSTR
	wire [25:0] Immaddrs;				// IMMEDIATE ADDRESS FIELD FROM INSTRS
	//CONTROL SIGNALS FROM MAIN CONTROL UNIT
	wire MemRead, MemWrite, MemtoReg, ALUsrc, RegWrite, RegDst, Branch, Jump, Jal, Jr, FPinst;
	wire [5:0] Opcode;				//OPCODE FIELD FROM INSTR
	wire [3:0] ALUop;				//ALUOP CONTROL SIGNAL
	wire [31:0] Extend, ALUInput, ALUResult;	
	wire ZERO;					//ZERO SIGNAL WIRE
	wire [4:0] Precision, Ft, Fs, Fd;
	wire [31:0] PCsum, PCsllout, Relativeadd,SumAdd;
	wire [31:0] Mux1add, Mux2add,Mux3add;		//CONNECTING WIRE FROM MUX OUTPUTS


	//PC MODULE  
	MIPS_PC pc0 ( GlobalClock, GlobalReset, Mux3add, PCout); // INPUTS GLOBAL CLOCK , GLOBAL RESET
	
	//INSTRUCTION MEMORY
	MIPS_INSTMEM im0 (PCout, Instruction);
	
	//REGULAR INSTRUCTIONS
	assign Opcode = Instruction[31:26];	//OPCODE
	assign ReadReg1 = Instruction[25:21]; 	// Rs
	assign ReadReg2 = Instruction[20:16];	 //Rt
	assign WriteReg = Instruction[15:11];  	//Rd
	assign Shamt = Instruction[10:6];	//SHAMT
	assign Funct = Instruction[5:0];	//Function
	assign Immaddrs = Instruction[25:0];	//Immediate Addrs
	assign Immfield = Instruction[15:0];	//Immediate Field
	
	//FlOATING INSTRUCTIONS
	assign Precision = Instruction[25:21]; 	// Precision Field
	assign Ft	= Instruction[20:16];	 //Ft
	assign Fs	 = Instruction[15:11];  //Fs
	assign Fd 	= Instruction[10:6];	//Fd
	
	//Main Control unit
	MIPS_CONTROLUNIT cu0 (Opcode,Precision, Funct, MemRead, MemWrite, MemtoReg, RegWrite, RegDst, ALUsrc, Branch, Jump, Jal, Jr, FPinst, ALUop);
	
	//Mux-0
	MIPS_MUX  #(5) m0(ReadReg2, WriteReg, RegDst, DestReg);

	//SIGN EXTEND MODULE
	MIPS_SIGNEXT se0 (Immfield, Extend);

	//SHIFT LEFT MODULE
	MIPS_SHL2 sl2 (Extend, Relativeadd);
	
	//REGISTER FILE
	MIPS_REGFILE rf0 (GlobalClock, ReadReg1, ReadReg2, DestReg, FPinst,Fs, Ft, Fd,  RegWrite, Jal, WriteData, PCout, ReadData1, ReadData2);

	//MUX -1
	MIPS_MUX  #(32) m1(ReadData2, Extend, ALUsrc, ALUInput);
	
	//ALU MODULE
	MIPS_ALU alu0 (ReadData1, ALUInput, ALUop, Shamt, ALUResult, ZERO);
	
	//DATA MEMORY MODULE
	MIPS_DATAMEM dm0 (ALUResult,MemWrite, MemRead, ReadData2, MemreadData );

	//MUX-2
	MIPS_MUX  #(32) m2(ALUResult, MemreadData, MemtoReg, WriteData);

	//ADDER MODULE-0
	MIPS_ADDER a0 (PCout,32'h4, PCsum);
	
	//PC SHIFT LEFT MODULE
	MIPS_PCSLL sl0 (Immaddrs, PCsum, PCsllout);
	
	//ADDER MODULE-1
	MIPS_ADDER a1 (PCsum, Relativeadd, SumAdd);

	//MUX MODULE-3
	MIPS_MUX  #(32) m3(PCsum, SumAdd, (Branch & ZERO) , Mux1add);

	//MUX MODULE-4
	MIPS_MUX  #(32) m4(Mux1add, PCsllout, Jump , Mux2add);
	
	//MUX MODULE-5
	MIPS_MUX  #(32) m5(Mux2add, ReadData1, Jr , Mux3add);
	
endmodule
