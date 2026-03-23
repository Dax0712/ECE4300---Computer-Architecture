
module control(
    input wire clk,
    input wire rst,
    input wire [5:0] opcode,
    output reg [1:0] wb,
    output reg [2:0] mem,
    output reg [3:0] ex
);

    parameter RTYPE = 6'b00_0000,
              LW    = 6'b10_0011,
              SW    = 6'b10_1011,
              BEQ   = 6'b00_0100,
              J     = 6'b00_0010;

    // default values
    initial begin
        wb = 2'd0;
        mem = 3'd0;
        ex = 4'd0;
    end

always @(posedge clk) begin
    if (rst) begin
        // COMPLETE: Set the outputs to 0
        wb = 2'd0;
        mem = 3'd0;
        ex = 4'd0;
    end

case (opcode)
    // General format of instruction:

    // Write-back stage control lines:
    // RegWrite, MemToReg

    // Memory access stage control lines: 
    // Branch, MemRead, MemWrite

    // Execution/Address Calculation stage control lines:
    // RegDst, ALUOp1, ALUOp0, ALUSrc

    //Instead of X, write 0
    
    RTYPE: begin
        wb = 2'b10; 
        mem = 3'b000; 
        ex = 4'b1100; 
    end

    LW: begin
        wb = 2'b11; 
        mem = 3'b010; 
        ex = 4'b0001; 
    end

    SW: begin
        wb = 2'b00; 
        mem = 3'b001; 
        ex = 4'b0001; 
    end

    BEQ: begin
        wb = 2'b00; 
        mem = 3'b100; 
        ex = 4'b0010; 
    end
endcase
end

endmodule