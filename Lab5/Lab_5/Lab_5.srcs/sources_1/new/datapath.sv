`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 00:10:46
// Design Name: 
// Module Name: datapath
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


module datapath (
    input logic clk, reset,
    input logic[2:0] ALUControlD,
    input logic BranchD,
    input logic [4:0] rsD, rtD, rdD,
    input logic [15:0] immD,
    output logic RegWriteE, MemToRegE, MemWriteE,
    output logic[31:0] ALUOutE, WriteDataE,
    output logic [4:0] WriteRegE,
    output logic [31:0] PCBranchE,
    output logic pcSrcE
);

    // Additional wire declarations needed
    logic [31:0] SignImmD, SignImmE;
    logic [31:0] SrcAE, SrcBE;
    logic [31:0] RD1D, RD2D;
    logic RegDstE, ALUSrcE;
    logic [4:0] RsE, RtE, RdE;
    
    // ... (keeping existing wire declarations) ...

    // Sign extension
    signext se(immD, SignImmD);

    // Register file connections (already given)
    regfile rf(clk, RegWriteW, instrD[25:21], instrD[20:16],
               WriteRegW, ResultW, RD1, RD2);

    // Hazard unit
    HazardUnit hu(
        .RegWriteW(RegWriteW),
        .WriteRegW(WriteRegW),
        .RegWriteM(RegWriteM),
        .MemToRegM(MemToRegM),
        .WriteRegM(WriteRegM),
        .RegWriteE(RegWriteE),
        .MemToRegE(MemToRegE),
        .rsE(RsE),
        .rtE(RtE),
        .rsD(instrD[25:21]),
        .rtD(instrD[20:16]),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .FlushE(FlushE),
        .StallD(StallD),
        .StallF(StallF)
    );

    // ALU and its input multiplexers
    mux3 #(32) forwardaemux(RD1E, ResultW, ALUOutM, ForwardAE, SrcAE);
    mux3 #(32) forwardbemux(RD2E, ResultW, ALUOutM, ForwardBE, WriteDataE);
    mux2 #(32) srcbmux(WriteDataE, SignImmE, ALUSrcE, SrcBE);

    alu mainalu(SrcAE, SrcBE, ALUControlE, ALUOutE, ZeroE);

    // Pipeline register instantiations
    PipeDtoE pipe_d_e(
        .clk(clk),
        .FlushE(FlushE),
        .RegWriteD(RegWriteD),
        .MemToRegD(MemToRegD),
        .MemWriteD(MemWriteD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .RegDstD(RegDstD),
        .RD1D(RD1),
        .RD2D(RD2),
        .RsD(instrD[25:21]),
        .RtD(instrD[20:16]),
        .RdD(instrD[15:11]),
        .SignImmD(SignImmD),
        // ... outputs connected to E stage signals ...
    );

    PipeEtoM pipe_e_m(
        .clk(clk),
        .RegWriteE(RegWriteE),
        .MemToRegE(MemToRegE),
        .MemWriteE(MemWriteE),
        .ALUOutE(ALUOutE),
        .WriteDataE(WriteDataE),
        .WriteRegE(WriteRegE),
        // ... outputs connected to M stage signals ...
    );

    PipeMtoW pipe_m_w(
        .clk(clk),
        .RegWriteM(RegWriteM),
        .MemToRegM(MemToRegM),
        .ReadDataM(ReadDataM),
        .ALUOutM(ALUOutM),
        .WriteRegM(WriteRegM),
        // ... outputs connected to W stage signals ...
    );

    // Branch logic
    sl2 immsh(SignImmE, SignImmSh);
    adder pcadd2(PcPlus4D, SignImmSh, PCBranchE);
    assign PcSrcE = BranchE & ZeroE;

endmodule
