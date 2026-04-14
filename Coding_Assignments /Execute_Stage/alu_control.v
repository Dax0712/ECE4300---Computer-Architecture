`timescale 1ns / 1ps
/*
Takes in 6 bits of funct with alu_op and outputs select, which is the control
for alu.v. This bridges machine language with assembly language.
*/

module alu_control(
    input wire [5:0] funct, // from ID/EX latch
    input wire [1:0] aluop,
    output reg [2:0] select
);

// These are the function field parameters for Rtype.
// ALU Op

parameter Rtype = 2'b10; // this is a 2-bit parameter

/*
    Radd = 2'b10,
    Rsub = 2'b10,
    Rand = 2'b10,
    Ror  = 2'b10,
    Rslt = 2'b10;
*/

parameter   lwsw = 2'b00,    // since LW and SW use the same bit pattern,
                             // only way to store them as a parameter
            Itype = 2'b01;   // beq, branch

// ALU Control Inputs designation
parameter   ALUadd = 3'b010,
            ALUsub = 3'b110,
            ALUand = 3'b000,
            ALUor  = 3'b001,
            ALUslt = 3'b111;

// If the input information does not correspond to any valid instruction,
// control = ALUx = 3'b011 and ALU output is 32 x's
parameter   ALUx = 3'b011;

// Funct Field
parameter   FUNCTadd = 6'b100000,
            FUNCTsub = 6'b100010,
            FUNCTand = 6'b100100,
            FUNCTor  = 6'b100101,
            FUNCTslt = 6'b101010;

always @(*) begin
    if (aluop == Rtype) begin
        case (funct)
            // assign the correct select value based on the funct field.
            // Desired ALU action
            FUNCTadd: select = ALUadd;
            FUNCTsub: select = ALUsub;
            FUNCTand: select = ALUand;
            FUNCTor:  select = ALUor;
            FUNCTslt: select = ALUslt;
            default:  select = ALUx; // for invalid funct field, set control to ALUx
        endcase
    end

    // Feel free to reuse any of the parameters defined above.

    else if (aluop == lwsw) begin
        select = ALUadd; // for lw and sw, the ALU should perform addition to calculate the address
    end
    else if (aluop == Itype) begin
        select = ALUsub; // for beq, the ALU should perform subtraction to compare the two registers
    end
    else begin
        select = ALUx;   // invalid ALUOp
    end
end

endmodule // alu_control