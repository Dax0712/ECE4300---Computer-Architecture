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
    wire zero;

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
        .zero(zero),
        .alu_result_out(alu_result_out),
        .rdata2_out(rdata2_out),
        .muxout_out(muxout_out)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // toggle clock every 5 time units
    end

    initial begin
        // initialize control signals that will remain the same for all test cases
        ctlwb_in   = 2'b10;
        ctlm_in    = 2'b01;
        npc        = 32'd100;
        instr_2016 = 5'd5;
        instr_1511 = 5'd10;

        //================================================================================================
        // Test 1: lw/sw style ADD operation using the sign-extended immediate.
        // ALUOp = 00 forces the ALU to add. RegDst = 0 selects rt = instr_2016.
        rdata1   = 32'd10;
        rdata2   = 32'd20;
        s_extend = 32'd4;
        alu_op   = 2'b00;
        funct    = 6'b000000; // funct is ignored for lw/sw style instructions
        alusrc   = 1'b1;
        regdst   = 1'b0;
        @(posedge clk);

        //================================================================================================
        // Test 2: BEQ style SUB operation where the two register values are equal.
        // ALUOp = 01 forces subtract. Zero should go high because 7 - 7 = 0.
        rdata1   = 32'd7;
        rdata2   = 32'd7;
        s_extend = 32'd8;
        alu_op   = 2'b01;
        funct    = 6'b100010; // funct is ignored for BEQ style instructions
        alusrc   = 1'b0;
        regdst   = 1'b0; // don't care for BEQ, but keeping it at 0 selects instr_2016
        @(posedge clk);

        //================================================================================================
        // Test 3: R-type ADD using rdata1 and rdata2.
        // ALUOp = 10 means R-type, so funct = 100000 selects ADD. RegDst = 1 selects rd = instr_1511.
        rdata1   = 32'd10;
        rdata2   = 32'd20;
        s_extend = 32'd12;
        alu_op   = 2'b10;
        funct    = 6'b100000; // ADD
        alusrc   = 1'b0;
        regdst   = 1'b1;
        @(posedge clk);

        //================================================================================================
        // Test 4: R-type SUB using rdata1 and rdata2.
        // funct = 100010 selects SUB.
        rdata1   = 32'd20;
        rdata2   = 32'd10;
        s_extend = 32'd16;
        alu_op   = 2'b10;
        funct    = 6'b100010; // SUB
        alusrc   = 1'b0;
        regdst   = 1'b1;
        @(posedge clk);

        //================================================================================================
        // Test 5: R-type AND using rdata1 and rdata2.
        // 12 & 10 = 8.
        rdata1   = 32'd12;
        rdata2   = 32'd10;
        s_extend = 32'd20;
        alu_op   = 2'b10;
        funct    = 6'b100100; // AND
        alusrc   = 1'b0;
        regdst   = 1'b1;
        @(posedge clk);

        //================================================================================================
        // Test 6: R-type OR using rdata1 and rdata2.
        // 12 | 10 = 14.
        rdata1   = 32'd12;
        rdata2   = 32'd10;
        s_extend = 32'd24;
        alu_op   = 2'b10;
        funct    = 6'b100101; // OR
        alusrc   = 1'b0;
        regdst   = 1'b1;
        @(posedge clk);

        //================================================================================================
        // Test 7: R-type SLT using rdata1 and rdata2.
        // 3 < 8, so the ALU should output 1.
        rdata1   = 32'd3;
        rdata2   = 32'd8;
        s_extend = 32'd28;
        alu_op   = 2'b10;
        funct    = 6'b101010; // SLT
        alusrc   = 1'b0;
        regdst   = 1'b1;
        @(posedge clk);
        #5 // to allow for the SLT output to show (adder_out, alu_result_out, rdata2_out)
        $stop;
    end

endmodule
