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



module MIPS_CORETB;
	
	// Inputs
	reg GlobalClock;
	reg GlobalReset;
	
	// Instantiate the Unit Under Test (UUT)
	MIPS_CORE uut (
		.GlobalClock(GlobalClock), 
		.GlobalReset(GlobalReset)
	);

	initial begin
		GlobalClock = 1;
		forever #50 GlobalClock = ~GlobalClock;

	end
	
	initial begin  
           // Initialize Inputs    
           GlobalReset = 1;  
           // Wait 200 ns for global reset to finish  // NECESSARY TO RESET THE CPU STATE ON BOOT
    	   #50 GlobalReset = 0;
	   #3300 $finish;  
      	end 



	
	
endmodule
