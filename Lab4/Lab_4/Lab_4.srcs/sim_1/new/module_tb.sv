`timescale 1ns/1ps

module alu_tb;

  // Define inputs and outputs
  logic [31:0] a, b;
  logic [2:0] alucont;
  logic [31:0] result;
  logic zero;

  // Instantiate the ALU module
  alu dut (
    .a(a),
    .b(b),
    .alucont(alucont),
    .result(result),
    .zero(zero)
  );

  // Test procedure
  initial begin
    // Monitor output values for easier debugging
    $monitor("Time: %0t | a: %h | b: %h | alucont: %b | result: %h | zero: %b", 
             $time, a, b, alucont, result, zero);
             
    // Test Addition (alucont = 010)
    a = 32'h00000003;
    b = 32'h00000002;
    alucont = 3'b010;
    #10;
    assert(result == 32'h00000005) else $fatal("Addition failed");

    // Test Subtraction (alucont = 110)
    a = 32'h00000005;
    b = 32'h00000003;
    alucont = 3'b110;
    #10;
    assert(result == 32'h00000002) else $fatal("Subtraction failed");

    // Test AND (alucont = 000)
    a = 32'h0000000F;
    b = 32'h00000003;
    alucont = 3'b000;
    #10;
    assert(result == 32'h00000003) else $fatal("AND failed");

    // Test OR (alucont = 001)
    a = 32'h0000000F;
    b = 32'h00000003;
    alucont = 3'b001;
    #10;
    assert(result == 32'h0000000F) else $fatal("OR failed");

    // Test SLT (alucont = 111) - a < b
    a = 32'h00000001;
    b = 32'h00000002;
    alucont = 3'b111;
    #10;
    assert(result == 32'h00000001) else $fatal("SLT failed (a < b)");

    // Test SLT (alucont = 111) - a >= b
    a = 32'h00000003;
    b = 32'h00000002;
    alucont = 3'b111;
    #10;
    assert(result == 32'h00000000) else $fatal("SLT failed (a >= b)");

    // Test Zero flag - result should be zero
    a = 32'h00000002;
    b = 32'h00000002;
    alucont = 3'b110;
    #10;
    assert(zero == 1'b1) else $fatal("Zero flag failed");

    // Test Zero flag - result should not be zero
    a = 32'h00000003;
    b = 32'h00000002;
    alucont = 3'b010;
    #10;
    assert(zero == 1'b0) else $fatal("Zero flag failed");

    $display("All ALU tests passed.");
    $finish;
  end

endmodule

