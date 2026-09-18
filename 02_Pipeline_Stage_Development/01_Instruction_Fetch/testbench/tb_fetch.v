`timescale 1ns / 1ps

module tb_fetch;

// testbench signals
reg clk;
reg rst;
reg ex_mem_pc_src;
reg [31:0] ex_mem_npc;

// outputs from fetch
wire [31:0] if_id_instr;
wire [31:0] if_id_npc;

fetch dut(
    .clk(clk),
    .rst(rst),
    .ex_mem_pc_src(ex_mem_pc_src),
    .ex_mem_npc(ex_mem_npc),
    .if_id_instr(if_id_instr),
    .if_id_npc(if_id_npc)
);

// Clock toggles every 5 ns
always #5 clk = ~clk; 

initial begin
    // initialize signals
    clk = 0;
    rst = 1;
    ex_mem_pc_src = 0;
    ex_mem_npc = 32'd0;

    // reset hold for a bit
    #10;
    rst = 0;

    // normal sequential fetching
    #30;

    // force mux to take EX/MEM NPC
    ex_mem_pc_src = 1;
    ex_mem_npc = 32'd20;
    #10;

    // back to normal fetching
    ex_mem_pc_src = 0;
    #20;

    // try another external npc value
    ex_mem_pc_src = 1;
    ex_mem_npc = 32'd8;
    #10;

    // back to normal fetching
    ex_mem_pc_src = 0;
    #30;

    $stop; // end sim
end

endmodule