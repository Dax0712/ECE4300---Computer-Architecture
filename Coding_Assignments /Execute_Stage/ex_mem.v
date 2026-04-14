`timescale 1ns / 1ps
/*
This is the latch that receives signals from all the modules of the execution stage.
Its outputs go to the MEM stage.
*/

module ex_mem(
    input wire clk,
    input wire [1:0] ctlwb_in,
    input wire [1:0] ctlm_in,
    input wire [31:0] adder_in,
    input wire [31:0] alu_in,
    input wire [31:0] readdat2_in,
    input wire [4:0] mux_in,
    output reg [1:0] ctlwb_out,
    output reg [1:0] ctlm_out,
    output reg [31:0] adder_out,
    output reg [31:0] alu_result_out, rdata2_out,
    output reg [4:0] muxout_out
);

initial begin
    ctlwb_out <= 0;
    ctlm_out <= 0;
    adder_out <= 0;
    alu_result_out <= 0;
    rdata2_out <= 0;
    muxout_out <= 0;
end

always @(posedge clk) begin
    ctlwb_out <= ctlwb_in;
    ctlm_out <= ctlm_in;

    adder_out <= adder_in;
    alu_result_out <= alu_in;
    rdata2_out <= readdat2_in;
    muxout_out <= mux_in;
end

endmodule // ex_mem