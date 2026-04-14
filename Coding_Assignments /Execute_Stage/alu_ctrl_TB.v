`timescale 1ns / 1ps
module test();

// Wire Ports
wire [2:0] select;

//Register Declarations
reg [1:0] alu_op;
reg [5:0] funct;

alu_control aluccontrol1(
    .select(select),
    .aluop(alu_op),
    .funct(funct)
);

initial begin
    alu_op = 2'b00; // lwsw
    funct = 6'b100000; // select = 010
    $monitor("ALUOp = %b\tfunct = %b\tselect = %b", alu_op, funct, select);

    #1

    alu_op = 2'b01; // I-type
    funct = 6'b100000; // funct is ignored for I-type instructions, so select (ALU control input) should be 110.

    #1

    alu_op = 2'b10; // R-type
    funct = 6'b100000; // instruction is ADD, select = 010

    #1

    funct = 6'b100010; // instruction is SUB, select = 110

    #1

    funct = 6'b100100; // instruction is AND, select = 000

    #1

    funct = 6'b100101; // instruction is OR, select = 001

    #1

    funct = 6'b101010; // instruction is SLT, select = 111

    $finish;
end

endmodule // alu_ctrl_TB