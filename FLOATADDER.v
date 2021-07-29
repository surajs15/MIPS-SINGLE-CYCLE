`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		Suraj Salian
// 
// Create Date:    19:41:11 02/17/2021 
// Design Name: 
// Module Name:     FLOAT_ADD
// Project Name: 

// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//


////////////////////////////Exponent Compare/////////////////////////////////////////////
module EXP_CMP(
	input	    [7:0] EXP_A, //Exponent of Input 1
	input	    [7:0] EXP_B, //Exponent of Input 2
	output	     EXP_INDI,	//Used to indicate the comparison result of exponents of input
	output	    [7:0] SHAMT	// Shift Amount is output -> |EXP_A - EXP_B|
);

	wire [7:0] DIFF_A, DIFF_B;
	// Difference of Exponents
	assign DIFF_A = (EXP_A) - (EXP_B);	
	assign DIFF_B = (EXP_B) - (EXP_A);
	
	//expA > expB -> expIndicate = 0 ; 		 	expA < expB -> expIndicate = 1 ; 
	assign EXP_INDI = ((EXP_A) >= (EXP_B))? 1'b0 : 1'b1;
	
	//expA > expB -> SHAMT = EXP_A - EXP_B ; 		 expA < expB -> SHAMT = EXP_B - EXP_A ;
	assign SHAMT = EXP_INDI ? DIFF_B : DIFF_A;

endmodule


////////////////////////////24-bit MUX/////////////////////////////////////////////
module MUX_24(
	input	[22:0] X,
	input	[22:0] Y,
	input 	expInd,
	input   X_zero,
	input	Y_zero,
	output  [23:0] out

);
	// 24-bits Mux; Bits[0:22} Fraction part of input
	assign out[22:0] = expInd? X[22:0] : Y[22:0];

	//Intial Assumption Inputs are always in Normalized form
	//If input number is non zero MSB Will always remain 1 --> {1.[fraction_part]} according to above condition
	assign out[23] = expInd?((X_zero?1'b0:1'b1)):(Y_zero?1'b0:1'b1);

endmodule


////////////////////////////Shift RIght Fraction/////////////////////////////////////////////
module FR_SHFT(
	input	    [23:0] FR_IN,
	input	    [7:0]  SHAMT,
	output	    [23:0] FR_OUT
);
	//Shifting Out the fraction part of smaller exponent
	assign FR_OUT = FR_IN >> (SHAMT);
	
endmodule


////////////////////////////8-bit MUX Exponent/////////////////////////////////////////////
module MUX_8(
	input	[7:0] X,
	input	[7:0] Y,
	input 	expInd,
	output  [7:0] out

);
	// 8-bits Mux; Bits[0:22} Exponent part of input
	assign out[7:0] = expInd? Y[7:0] : X[7:0];
// Module used to Output the Higher Exponent

endmodule


//////////////////////////// Comparison of Bigger Input /////////////////////////////////////////////
module CHECK_B(
	input	[30:0] X,
	input	[30:0] Y,
	output   out_ind

);
	// MUX used to Compare the absolute value of two inputs A & B
	// A> B --> out_ind = 0  | B>A -->out_ind = 1
	assign out_ind = (X > Y)? 1'b0 : 1'b1;


endmodule


//////////////////////////// BIG ALU ( ADDITION & SUBTRACTION) /////////////////////////////////////////////
module BIG_ALU(
	input sgnA,
	input sgnB,
	input bignum,
	input	[23:0] A_s,
	input	[23:0] B_s,
	output	reg	 sgnOut,
	output  reg [24:0] sumOut

);
	always @(sgnA,sgnB,A_s,B_s,bignum)
	begin
		if(sgnA == sgnB)		 // sign of both inputs are same
		begin
			sumOut = A_s + B_s;	// If sign of two inputs are same perform addition operation
			sgnOut = sgnA;		// Output sign  = sign of Input A
		end

		else				// sign of both inputs are opposite perform subtraction
		begin
			// Case when signs are opposite do: Output = Bigger - Smaller
		
			if(bignum ==0)		// Input A > Input B		
			begin
				sumOut = A_s - B_s;	// A - B	
				sgnOut = sgnA;		// Output sign = Sign(input A)
			end
		
			else			//Input B > Input A
			begin
				sumOut = B_s - A_s;	// B - A
				sgnOut = sgnB;		// Output sign = Sign(input B)
			end	
		end
	end
	

endmodule


//////////////////////////// ROUNDING / NORMALISATION HARD /////////////////////////////////////////////
module ROUND(
	input	[24:0] frin,
	input	[7:0]  expIn,
	input	sgnOut,
	output	reg	[7:0]  expfIn,
	output  reg [22:0] frsOut,
	output  reg	sgOut
);
	
	reg [24:0] ftemp;
	
	always @(frin,expIn,sgnOut)
	begin
		ftemp[24:0] = frin[24:0];	
		expfIn[7:0] = expIn[7:0];
		if(ftemp!=0)		//checking for Mantissa result of BIG ALU ! = 0
		begin
			if(ftemp[24]==1'b1)		// carry generated : hence normalise output
			begin
				ftemp = ftemp >> 1;		// shift Mantissa Right by 1-bit
				expfIn = expfIn + 1'b1;		//Increment Exponent
			end
			else
			begin
				//Carry Not generated and denormalized form
				repeat(24)
				begin
					if(ftemp[23]==0)		//shift left until output is normalized
					begin
						ftemp = ftemp << 1'b1;
						expfIn = expfIn - 1;
					end
				end
			end
			sgOut = sgnOut;
			frsOut[22:0] = ftemp[22:0];
			
		end

		if(ftemp == 0)		//checking for Mantissa result of BIG ALU  == 0
		// In this case the output result = 0
		begin
			expfIn= 8'b0;		//Output exponent = 0
			sgOut = 1'b0;		//Output Sign bit = 0
			frsOut[22:0] = 22'b0;	//output Mantissa  = 0
		end
	
	
		//////////////Output Exceptions////////////////////////////////////////////
		if(expfIn == 8'd255)	// Exponent = 255 overflow occurs ;  Output = Infinity
		begin
			frsOut[22:0] = 22'b0;	//output Mantissa  = 0
			sgOut = sgnOut;
		end
		
		// Exponent = 0 underflow occurs ;  Output = 0
		if(expfIn == 8'd0)
		begin
			frsOut[22:0] = 22'b0;	//output Mantissa  = 0
			sgOut = 0;		//Output Sign bit = 0
		end
	end


endmodule
 


////////////////////////////**********************Main Module FLoating Point Adder*********************/////////////////////////////////////////////
//Initial Assumptions Inputs are in IEEE-754 format
//Number is a floating point number in normalized form;

module FLOAT_ADD(
	input	[31:0] A,		//Input-1
	input	[31:0] B,		//Input-2
	output  [31:0] Out 		// contain the final output in IEEE-754 format
);
	wire [7:0] expA, expB; 		// Wires to separate out the exponent from the given input format


	// shift is being used to the fraction part of number with smaller exponent
	wire [7:0] shift;		// shift is used to extract the absolute difference between the two exponents
	

	//expA > expB -> expIndicate = 0 ; | expA < expB -> expIndicate = 1 ; 
	wire expIndicate;			//expIndicate is used to indicate the comparison result of  exponents of given input;
			
	wire [22:0] frA, frB ;			// Wires to separate out the fraction part from the given input format

	wire [23:0] muxout1, muxout2;		//muxout1 is used to store the fraction part of the input with smaller input; muout 2 ---> fraction part of bigger input

	wire [23:0] frOut;			//frOut used to extract the right-shifted fraction part

	wire [7:0] expOut;			// Output of the mux which selects the bigger exponent of two inputs

	wire [23:0] A_s, B_s;			// wires to connect the processed the mantissa's of two inputs respectively
	
	wire [24:0] fadderout;			//output of the adder operation

	
	wire sgnA, sgnB, sgnOut;		//sgnA --> sign bit Input A  | sgnB --> sign bit Input B
	

	// Input A > Input B --> bigIndicate = 0 | else bigIndicate = 1
	wire bigIndicate;			// Output of the MUX to indicate the comparison of two inputs;
	

	//connecting wires to the exponent part of inputs bit(23-30)
	assign expA[7:0] = A[30:23];
	assign expB[7:0] = B[30:23];
	
	//connecting wires to the fraction part of inputs bit(0-22)
	assign frA[22:0] = A[22:0];
	assign frB[22:0] = B[22:0];
	
	//connecting wires to the sign bit of inputs 
	assign sgnA = A[31];
	assign sgnB = B[31];	
	
	wire expAff, expBff;		//wire to indicate respective Exponent is = 255_d
	wire expA_zero, expB_zero;	//wire to indicate  respective exponent is zer0
	wire frA_zero, frB_zero;	//wire to indicate respective fractional part = 0
	wire A_zero, B_zero;		//wire to indicate any input = 0
	
	wire  A_INF, B_INF;		// Set if Respective input is infinity
	wire INP_INF;			// Set only if one of the input is infinity
	wire TWO_INF;			// set if both inputs are infinity and of same sign
	
	// Input exception signals
	assign expAff = &A [30:23];	//set if Exponent of Input A = 255_d
	assign expBff = &B[30:23];	//set if  respective Exponent of Input B = 255_d

	assign expA_zero = ~|A [30:23];	 //set if Exponent of Input A = 0
	assign expB_zero = ~|B [30:23];	 //set if Exponent of Input B = 0

	assign frA_zero = ~|A [22:0];	//set if fractional part of Input A = 0
	assign frB_zero = ~|B [22:0];	//set if fractional part of Input B = 0

	assign A_zero = expA_zero & frA_zero;	//set if input A = 0
	assign B_zero = expB_zero & frB_zero;	//set if input B = 0

	// Instantiating the module which gives the absolute amount of shift and outputs expIndicate
	EXP_CMP CMP0(expA,expB,expIndicate,shift);

	//MUX m0 gives the fraction part of the input with smaller exponent value
	MUX_24  m0  (frA,frB, expIndicate,A_zero, B_zero, muxout1);
	
	//MUX m1 gives the fraction part of the input with bigger exponent value
	MUX_24  m1  (frB,frA, expIndicate,B_zero, A_zero, muxout2);

	//Right shifting the fraction part of the number with smaller exponent, shift amount is passed parameter 'shift'
	FR_SHFT s0  (muxout1,shift,frOut);
	
	//MUX e0 gives the Exponent part of the input with higher exponent value
	MUX_8  e0  (expA,expB, expIndicate,expOut);

	//Assigning the processed fraction part of Input A
	assign A_s = (expIndicate)? frOut:muxout2;

	//Assigning the processed fraction part of Input A
	assign B_s = (expIndicate)? muxout2:frOut;

	// MUX used to Compare the absolute value of two inputs A & B
	CHECK_B c0 (A[30:0],B[30:0],bigIndicate);	// A> B --> bigIndicate = 0  | B>A -->bigIndicate = 1
	
	//BIG ALU b0 used to perform the arithmetic operation ADD/SUB
	BIG_ALU b0 (sgnA,sgnB,bigIndicate,A_s,B_s,sgnOut,fadderout);
	
		
	wire [22:0] fracfin;	// Output fraction part (22 bits) from Rounding  Hardware
	wire [7:0] expfin;	//Output exponent part (8bits) from rounding harware
	wire sgnfin;		//Output sign bits from the rounding hardware


	//Rounding Hardware used for normalizing the result in IEEE 754 format
	ROUND r0 (fadderout, expOut, sgnOut, expfin, fracfin,sgnfin);

	////////////////////////////////**** EXCEPTION HANDLER FOR INPUTS/********//////////////////////////////////////

	// Exception for Input Infinity

	assign A_INF = expAff & (frA_zero) ;	// Set if input A is infinity
	assign B_INF = expBff & (frB_zero) ;	// Set if input B is infinity
	
	// Set only if one of the input is infinity
	assign TWO_INF   = ( A_INF & B_INF & (~(sgnA ^ sgnB)) ); 	// Output in this case should be always +/- Infinity

	// set if both inputs are infinity and of same sign
	assign INP_INF = (A_INF ^ B_INF) ; 				// Output in this case should be always +/- Infinity

	//If input exception for Infinity Occurs final output is always infinity   |  else final Output is output of rounding hardware
	assign Out[31:0] = (INP_INF |TWO_INF)?(bigIndicate?{sgnB,8'hFF,23'b0}:{sgnA,8'hFF,23'b0}):{sgnfin,expfin,fracfin};
	

endmodule





