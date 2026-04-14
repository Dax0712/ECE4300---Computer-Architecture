`timescale 1ns / 1ps
/*
This is the testbench for the execution stage of the MIPS processor.
It tests the adder, alu_control, bottom_mux, top_mux, alu, and ex_mem modules together.
*/

module execute_TB;

    reg clk;
    reg [1:0] ctlwb_in, ctlm_in;
    reg [31:0] npc, rdata1, rdata2, s_extend;
    reg [4:0] instr_2016, instr_1511;
    reg [1:0] alu_op;
    reg [5:0] funct;
    reg alusrc, regdst;

    wire [1:0] ctlwb_out, ctlm_out;
    wire [31:0] adder_out, alu_result_out, rdata2_out;
    wire [4:0] muxout_out;

    Execute uut (
        .clk(clk),
        .ctlwb_in(ctlwb_in),
        .ctlm_in(ctlm_in),
        .npc(npc),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .s_extend(s_extend),
        .instr_2016(instr_2016),
        .instr_1511(instr_1511),
        .funct(funct),
        .alu_op(alu_op),
        .alusrc(alusrc),
        .regdst(regdst),
        .ctlwb_out(ctlwb_out),
        .ctlm_out(ctlm_out),
        .adder_out(adder_out),
        .alu_result_out(alu_result_out),
        .rdata2_out(rdata2_out),
        .muxout_out(muxout_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // toggle clock every 5 time units
    end

    initial begin
        // initialize inputs for first test case
        ctlwb_in   = 2'b10;
        ctlm_in    = 2'b01;
        npc        = 32'd100;
        rdata1     = 32'd10;
        rdata2     = 32'd20;
        s_extend   = 32'd4;
        instr_2016 = 5'd5;
        instr_1511 = 5'd10;
        alu_op     = 2'b10;
        funct      = 6'b100000; // ADD
        alusrc     = 1'b1;
        regdst     = 1'b1;

        // wait so outputs latch cleanly on next posedge
        @(negedge clk);

        // second test case
        alusrc     = 1'b0;
        regdst     = 1'b0;
        s_extend   = 32'd8;
        alu_op     = 2'b01;     // BEQ-style subtract path
        funct      = 6'b100010; // ignored here since alu_op = 01

        @(negedge clk);

        $stop;
    end

endmodule