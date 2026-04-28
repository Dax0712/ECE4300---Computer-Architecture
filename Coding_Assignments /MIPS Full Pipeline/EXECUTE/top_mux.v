`timescale 1ns / 1ps
/*
Implements a multiplexer that selects from two inputs (32 bits), a and b, based on the select input. (ALU src)
Its inputs are rdata2 and s_extend, from ID/EX latch, and alusrc.
The output is alu_b, which is sent to the ALU as the second operand.
*/

module top_mux(
    output wire [31:0] y,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire sel
);

assign y = sel ? b : a;

// Essentially and intuitively means:
// if sel == 0, then y = a (rdata2, second register data)
// if sel == 1, then y = b (s_extend, sign-extended immediate value)

endmodule // top_mux