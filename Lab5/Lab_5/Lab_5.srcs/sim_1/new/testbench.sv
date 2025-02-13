`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2024 00:29:02
// Design Name: 
// Module Name: testbench
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


module pipelined_mips_tb();
    logic clk, reset;
    logic [31:0] pc, instr, readdata;
    logic memwrite;
    logic [31:0] aluout, writedata, instrOut, resultW;

    // Clock generation
    initial begin
        clk = 0;
        #5;
        forever begin
            clk = ~clk;
            #5;
        end
    end

    // Instruction memory
    imem imem(
        .addr(pc[7:2]),
        .instr(instr)
    );

    // Data memory
    dmem dmem(
        .clk(clk),
        .we(memwrite),
        .a(aluout),
        .wd(writedata),
        .rd(readdata)
    );

    // DUT
    mips dut(
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instr(instr),
        .memwrite(memwrite),
        .aluout(aluout),
        .resultW(resultW),
        .instrOut(instrOut),
        .readdata(readdata)
    );

    // Test sequence
    initial begin
        // Initialize
        reset = 1;
        readdata = 0;
        
        // Hold reset for a few cycles
        repeat(3) @(posedge clk);
        
        // Release reset
        reset = 0;
        
        // Run for several cycles
        repeat(20) @(posedge clk);
        
        // Check results
        if (pc === 'x || pc === 'z) begin
            $display("Error: PC is undefined");
        end
        
        $finish;
    end

    // Debug monitoring
    always @(posedge clk) begin
        $display("\nTime=%0t", $time);
        $display("PC=%h", pc);
        $display("Instruction=%h", instr);
        if (memwrite) begin
            $display("Memory write: addr=%h data=%h", aluout, writedata);
        end
    end

endmodule