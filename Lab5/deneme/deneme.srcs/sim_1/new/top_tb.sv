`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 09:29:55
// Design Name: 
// Module Name: top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tb();

    // instance variables
    logic clk, reset;
    logic [31:0] instrD, resultW, WriteDataM, pc;
    logic MemWriteM, StallD, StallF;
    logic [31:0] aluout;
    
    // device under test initialization
    top dut(clk, reset,
    instrD, resultW, aluout, WriteDataM, pc,
    MemWriteM, StallD, StallF
    );
    
    //mips dut(clk, reset,
      //       pc,
        //     instr,
          //   aluout, resultW,
           //  instrD, WriteDataM,
            // StallD, StallF);
    
    // start test
    initial
        begin
        clk = 0;
        reset = 1;
        #20ns; 
        reset = 0;
        end
    
    always
        begin
            #10;
            clk = ~clk; // 10 ns clock rise edge
        end
        
endmodule
