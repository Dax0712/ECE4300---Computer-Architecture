`timescale 1ns / 1ps
/*
This is the latch that receives signals from all the modules of the execution stage.
Its outputs go to the MEM stage.
*/

module ex_mem(
    input wire clk,
    input wire rst,
    input wire [1:0] ctlwb_in,
    input wire [2:0] ctlm_in, // updated correction made to be 2 -> 3 bits.
    input wire [31:0] adder_in,
    input wire [31:0] alu_in,
    input wire [31:0] readdat2_in,
    input wire [4:0] mux_in,
    input wire zero_in,
    output reg [1:0] ctlwb_out,

    // output reg [1:0] ctlm_out this becomes 3 output signals instead
    output reg memread_out,
    output reg memwrite_out,
    output reg membranch_out,

    output reg [31:0] adder_out,
    output reg zero_out,
    output reg [31:0] alu_result_out, rdata2_out,
    output reg [4:0] muxout_out
);

/*
initial begin
    ctlwb_out <= 0;
    // ctlm_out <= 0;
    memread_out = 0;
    memwrite_out = 0;
    membranch_out = 0;

    adder_out <= 0;
    zero_out <= 0;
    alu_result_out <= 0;
    rdata2_out <= 0;
    muxout_out <= 0;
end
*/

always @(posedge clk) begin
    if (rst) begin
        ctlwb_out <= 2'b00;

        membranch_out <= 1'b0;
        memread_out   <= 1'b0;
        memwrite_out  <= 1'b0;

        adder_out      <= 32'b0;
        zero_out       <= 1'b0;
        alu_result_out <= 32'b0;
        rdata2_out     <= 32'b0;
        muxout_out     <= 5'b0;
    end
    else begin
        ctlwb_out <= ctlwb_in;

        membranch_out <= ctlm_in[2];
        memread_out   <= ctlm_in[1];
        memwrite_out  <= ctlm_in[0];

        adder_out      <= adder_in;
        zero_out       <= zero_in;
        alu_result_out <= alu_in;
        rdata2_out     <= readdat2_in;
        muxout_out     <= mux_in;
    end
end

endmodule // ex_mem