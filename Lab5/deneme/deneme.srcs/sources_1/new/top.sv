`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 09:28:26
// Design Name: 
// Module Name: top
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


module top(
 input logic clk, reset,
    output logic[31:0] instrD, resultW, aluout, WriteDataM, pc,
    output logic MemWriteM, StallD, StallF
    );
    // write the ones you want to see in simulation as ouput
    // stalls are for debug puposes
    
    // others just define as logic
    logic [31:0]  instr;
    // control system through a reset button

    // instantiate mips processor
    mips mips1(clk, reset,
             pc,
             instr,
             aluout, resultW,
             instrD, WriteDataM,
             StallD, StallF);
             
     // instantiate instruction memory
     imem imem1(pc[7:2],
                instr);
     // instantiate data memory
     //dmem demem1( clk, MemWriteM,
           //  aluout, WriteDataM,
           //  ReadDataW);
endmodule
