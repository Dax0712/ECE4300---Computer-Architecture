`timescale 1ps/1ps
/*
Tests alu.v
Which takes in the ALU control signal and outputs the result of the ALU operation.
*/

module alu_test();

// Inputs
reg [31:0] a;
reg [31:0] b;
reg [2:0] control;

// Outputs
wire [31:0] result;
wire zero;

// Instatiate the Unit Under Test (UUT)
alu uut (
    .a(a),
    .b(b),
    .control(control),
    .result(result),
    .zero(zero)
);

initial begin
    a = 32'd10;
    b = 32'd7;
    control = 3'b010;
    #1;
    
/*
$display is used to print the values of a and b at the start of the simulation.
$monitor continuously monitors and prints the values of control, result, and zero whenever they change.
*/

$display("A = %b\t B = %b", a, b);
$monitor("ALUop = %b\t result = %b\t zero = %b", control, result, zero);

    #1 

    control <= 'b100; // is this a valid control signal? No, should be ALUx, unknown control signal

    #1

    control <= 'b010; // result = 17, check ADD

    #1

    control <= 'b111; // result = 1, check SLT

    #1

    control <= 'b011; // ALUx, unknown control signal

    #1

    control <= 'b110; // result = 3, check SUB

    #1

    control <= 'b001; // result = 'b1111, check OR
    #1

    control <= 'b000; // result = 'b0010, check AND

    #1

    $finish;
end

endmodule // alu_test