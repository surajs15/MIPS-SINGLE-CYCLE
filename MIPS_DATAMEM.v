`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		Suraj Salian
// 
// Create Date:    19:41:11 02/17/2021 
// Design Name: 
// Module Name:     DATA MEMORY
// Project Name: 

// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////DATA MEMORY MODULE////////////////////////////
module MIPS_DATAMEM(
	input 	[31:0] Address, //INPUT ADDRESS
	input	Memwrite,	//MEMORY WRITE SIGNAL
	input	Memread,	//MEMORY READ SIGNAL
	input	[31:0] WriteData,	//WRITE DATA
	output	reg [31:0] ReadData	//OUTPUT READ DATA
);
	reg [7:0] RAM [511:0];
	integer i;
	initial begin
		$readmemb("Data.mem", RAM);
	end
	
	always @(Memread, Address, Memwrite, WriteData)
	begin 
		if (Memwrite == 1'b1)  //WRITE OPEARTION
		begin
			RAM[Address] = WriteData[7:0];
			RAM[Address+1] = WriteData[15:8]; 
			RAM[Address+2] = WriteData[23:16];
			RAM[Address+3] = WriteData[31:24];
			$writememb("MEMDATA.mem", RAM);
		end
	
		if (Memread == 1'b1)	//READ OPERATION
		begin
			ReadData[31:0] = {RAM[Address+3],RAM[Address+2],RAM[Address+1],RAM[Address]}; 
		end
	end

	
endmodule
