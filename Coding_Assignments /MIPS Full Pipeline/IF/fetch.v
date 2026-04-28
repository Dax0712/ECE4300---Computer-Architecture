`timescale 1ns / 1ps

module fetch(
    input wire        clk,
    input wire        rst,
    input wire        ex_mem_pc_src,
    input wire [31:0] ex_mem_npc,
    output wire [31:0] if_id_instr,
    output wire [31:0] if_id_npc
);

    wire [31:0] pc_out;
    wire [31:0] pc_mux;
    wire [31:0] next_pc;
    wire [31:0] instr_data;


    // choose either the next pc or the branch pc
    mux m0(
        .y(pc_mux),
        .a_true(ex_mem_npc),
        .b_false(next_pc),
        .sel(ex_mem_pc_src)
    );


    // current pc
    pc pc0(
        .clk(clk),
        .rst(rst),
        .pc_in(pc_mux),
        .pc_out(pc_out)
    );


    // normal next pc
    incrementer in0(
        .clk(clk),
        .rst(rst),
        .pc_in(pc_out),
        .pc_out(next_pc)
    );


    // instruction memory
    instrMem inMem0(
        .clk(clk),
        .rst(rst),
        .addr(pc_out),
        .data(instr_data)
    );


    // if/id latch
    ifIdLatch ifIdLatch0(
        .clk(clk),
        .rst(rst),
        .pc_in(next_pc),
        .instr_in(instr_data),
        .pc_out(if_id_npc),
        .instr_out(if_id_instr)
    );

endmodule