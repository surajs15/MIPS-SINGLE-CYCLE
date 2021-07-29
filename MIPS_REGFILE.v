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
/////////////////////////////////////REGISTER FILE//////////////////////////////////
module MIPS_REGFILE(
	input   CLK,			//INPUT CLOCK
	input 	[4:0] ReadReg1,		//READ REG-1
	input 	[4:0] ReadReg2,		//READ REG-2
	input 	[4:0] WriteReg,		//WRITE REG
	input   FPinst,			//FLOATING INSTR
	input 	[4:0] Fs,		//READ REG-1
	input 	[4:0] Ft,		//READ REG-2
	input 	[4:0] Fd,		//WRITE REG
	input   RegWrite,		//REGISTER WRITE SIGNAL
	input   Jal,			// JUMP AND LINK SIGNAL
	input 	[31:0] WriteData,	//WRITE DATA
	input 	[31:0] PC,		//INPUT PC
	output	reg [31:0] ReadData1,	//OUTPUT READ DATA1
	output	reg [31:0] ReadData2	//OUTPUT READ DATA2
);
	reg [31:0] REG[31:0];		//REG FILE FOR 32 REGS
	reg [31:0] FloatREG[31:0];	//REG FILE FOR 32 FLOATING POINT REGS
	integer i;
	initial begin
		$readmemb("REGINP.mem", REG);
		$readmemb("FPREGINP.mem", FloatREG);
	end

	
	always @(posedge CLK)
	begin
		if(RegWrite == 1'b1 && FPinst == 1'b0)		//WRITE OPERATION
		begin
			REG[WriteReg] = WriteData;
			REG[0] = 32'b0;
			$writememb("REGDATA.mem", REG);
		end
	
		if(RegWrite == 1'b1 && FPinst == 1'b1)		//WRITE OPERATION
		begin
			FloatREG[Fd] = WriteData;
			$writememb("FPREGDATA.mem", FloatREG);
		end

		if(Jal == 1'b1 && FPinst == 1'b0)		//LINKING PC+4 TO $RA
		begin
			REG[31] = PC+4;
			$writememb("REGDATA.mem", REG);
		end
	end

	always @(ReadReg1,ReadReg2,FPinst, Fs,Ft, Fd)		//READ REGISTER DATA
	begin
		if(FPinst == 1'b0)		//LINKING PC+4 TO $RA
		begin
			ReadData1 = REG[ReadReg1];
			ReadData2 = REG[ReadReg2];
		end
		else if(FPinst == 1'b1)		//LINKING PC+4 TO $RA
		begin
			ReadData1 = FloatREG[Fs];
			ReadData2 = FloatREG[Ft];
		end
	end

	
endmodule
