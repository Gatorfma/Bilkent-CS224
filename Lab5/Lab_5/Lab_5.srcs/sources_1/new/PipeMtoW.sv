`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 00:09:53
// Design Name: 
// Module Name: PipeMtoW
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


module PipeMtoW(
    input logic clk,
    // Control signals
    input logic RegWriteM, MemToRegM,
    // Data signals
    input logic [31:0] ReadDataM, ALUOutM,
    input logic [4:0] WriteRegM,
    // Outputs
    output logic RegWriteW, MemToRegW,
    output logic [31:0] ReadDataW, ALUOutW,
    output logic [4:0] WriteRegW
);
    always_ff @(posedge clk) begin
        // Control signals
        RegWriteW <= RegWriteM;
        MemToRegW <= MemToRegM;
        // Data signals
        ReadDataW <= ReadDataM;
        ALUOutW <= ALUOutM;
        WriteRegW <= WriteRegM;
    end
endmodule
