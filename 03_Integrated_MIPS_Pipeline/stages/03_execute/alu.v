`timescale 1ns / 1ps
/*
Takes in rdata1 as its input as well as "b," which is the output of top_mux.
It outputs the result, later known as aluout, and zero, which is then aluzero for ex_mem.v.
This handles the loggical and arithmetic correspondence.
*/

module alu(
    input wire [31:0] a, // source from register
    input wire [31:0] b, // target from register
    input wire [2:0] control, // select from alu_control
    
    output reg[31:0] result, // goes to MEM Data memory and MEM/WB latch
    output wire zero // goes to MEM Branch
);

// Based on Lab 3-2 Instruction Operation and ALU control
parameter   ALUadd = 3'b010,
            ALUsub = 3'b110,
            ALUand = 3'b000,
            ALUor  = 3'b001,
            ALUslt = 3'b111;

always@*
    case(control)
        ALUadd: result = a + b;
        ALUsub: result = a - b;
        ALUand: result = a & b; // changed to bit-wise AND, should not be logical AND (&&)
        ALUor: result  = a | b; // changes to bit-wise OR, should not be logical OR (||)
        
        // for signed set-less-than, 
        // output 1 if a < b,
        // output 0 otherwise
        ALUslt: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // use signed comparison for SLT.

        default: result = 32'bx; // control = ALUx | *
    endcase
    
// FLAG used for branch instructions. It is set to 1 if the result of the ALU operation is zero, and 0 otherwise.
// check to see if result is equal to zero. If it is, assign it true (1), false (0) otherwise,
// meaning it is a non-zero number.

/* result = (condition1) ? rA : (condition2) ? rB : rC */
assign zero = (result == 0) ? 1 : 0; // result == 0 is the condition, if true, assign 1, else assign 0.

endmodule