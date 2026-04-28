`timescale 1ns / 1ps

// mips_pipeline_tb.v

module mips_pipeline_tb;

    reg clk;
    reg rst;


    // -------------------------
    // waveform wires
    // -------------------------

    wire [31:0] instr_out;
    wire [31:0] npc_out;
    wire [31:0] read_data1_out;
    wire [31:0] read_data2_out;
    wire [31:0] alu_result_out;
    wire [31:0] mem_read_data_out;
    wire [31:0] write_data_out;
    wire [4:0]  write_reg_out;
    wire        regwrite_out;
    wire        memtoreg_out;
    wire        pcsrc_out;


    // -------------------------
    // full pipeline
    // -------------------------

    mips_pipeline uut (
        .clk(clk),
        .rst(rst),

        .instr_out(instr_out),
        .npc_out(npc_out),
        .read_data1_out(read_data1_out),
        .read_data2_out(read_data2_out),
        .alu_result_out(alu_result_out),
        .mem_read_data_out(mem_read_data_out),
        .write_data_out(write_data_out),
        .write_reg_out(write_reg_out),
        .regwrite_out(regwrite_out),
        .memtoreg_out(memtoreg_out),
        .pcsrc_out(pcsrc_out)
    );


    // -------------------------
    // clock
    // -------------------------

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end


    // -------------------------
    // reset
    // -------------------------

    initial begin
        rst = 1;
        #10 rst = 0;

        #200 $finish;
    end

endmodule