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

// pick between normal next pc or branch target
mux m0(
    .y(pc_mux),
    .a_true(ex_mem_npc),
    .b_false(next_pc),
    .sel(ex_mem_pc_src)
);

pc pc0(
    .clk(clk),
    .rst(rst),
    .pc_in(pc_mux),
    .pc_out(pc_out)
);

// pc + 4
incrementer in0(
    .clk(clk),
    .rst(rst),
    .pc_in(pc_out),
    .pc_out(next_pc)
);

instrMem inMem0(
    .clk(clk),
    .rst(rst),
    .addr(pc_out),
    .data(instr_data)
);

// holds instruction and npc for next stage
ifIdLatch ifIdLatch0(
    .clk(clk),
    .rst(rst),
    .pc_in(next_pc),
    .instr_in(instr_data),
    .pc_out(if_id_npc),
    .instr_out(if_id_instr)
);

endmodule