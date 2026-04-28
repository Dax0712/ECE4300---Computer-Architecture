`timescale 1ns / 1ps

// mips_pipeline.v

module mips_pipeline(
    input wire clk,
    input wire rst,

    // extra outputs so the waveform is easier to check
    output wire [31:0] instr_out,
    output wire [31:0] npc_out,
    output wire [31:0] read_data1_out,
    output wire [31:0] read_data2_out,
    output wire [31:0] alu_result_out,
    output wire [31:0] mem_read_data_out,
    output wire [31:0] write_data_out,
    output wire [4:0]  write_reg_out,
    output wire        regwrite_out,
    output wire        memtoreg_out,
    output wire        pcsrc_out
);

    // -------------------------
    // fetch to decode
    // -------------------------

    wire [31:0] if_id_instr;
    wire [31:0] if_id_npc;


    // -------------------------
    // decode to execute
    // -------------------------

    wire [1:0] id_ex_wb;
    wire [2:0] id_ex_mem;
    wire [3:0] id_ex_execute;

    wire [31:0] id_ex_npc;
    wire [31:0] id_ex_readdat1;
    wire [31:0] id_ex_readdat2;
    wire [31:0] id_ex_sign_ext;

    wire [4:0] id_ex_instr_bits_20_16;
    wire [4:0] id_ex_instr_bits_15_11;

    // ex = {RegDst, ALUOp1, ALUOp0, ALUSrc}
    wire id_ex_regdst;
    wire id_ex_alusrc;
    wire [1:0] id_ex_aluop;

    assign id_ex_regdst = id_ex_execute[3];
    assign id_ex_aluop  = id_ex_execute[2:1];
    assign id_ex_alusrc = id_ex_execute[0];


    // -------------------------
    // execute to memory
    // -------------------------

    wire [1:0] ex_mem_wb;

    wire ex_mem_memread;
    wire ex_mem_memwrite;
    wire ex_mem_membranch;

    wire [31:0] ex_mem_adder_result;
    wire ex_mem_zero;
    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_readdat2;
    wire [4:0] ex_mem_write_reg;


    // -------------------------
    // memory to writeback
    // -------------------------

    wire mem_pcsrc;

    wire mem_wb_regwrite;
    wire mem_wb_memtoreg;

    wire [31:0] mem_read_data;
    wire [31:0] mem_alu_result;
    wire [31:0] write_data;

    wire [4:0] mem_write_reg;


    // -------------------------
    // fetch stage
    // -------------------------

    fetch fetch0(
        .clk(clk),
        .rst(rst),

        .ex_mem_pc_src(mem_pcsrc),
        .ex_mem_npc(ex_mem_adder_result),

        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc)
    );


    // -------------------------
    // decode stage
    // -------------------------

    decode decode0(
        .clk(clk),
        .rst(rst),

        // writeback path back into the register file
        .wb_reg_write(mem_wb_regwrite),
        .wb_write_reg_location(mem_write_reg),
        .mem_wb_write_data(write_data),

        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc),

        .id_ex_wb(id_ex_wb),
        .id_ex_mem(id_ex_mem),
        .id_ex_execute(id_ex_execute),
        .id_ex_npc(id_ex_npc),
        .id_ex_readdat1(id_ex_readdat1),
        .id_ex_readdat2(id_ex_readdat2),
        .id_ex_sign_ext(id_ex_sign_ext),
        .id_ex_instr_bits_20_16(id_ex_instr_bits_20_16),
        .id_ex_instr_bits_15_11(id_ex_instr_bits_15_11)
    );


    // -------------------------
    // execute stage
    // -------------------------

    Execute execute0(
        .clk(clk),
        .rst(rst),

        .ctlwb_in(id_ex_wb),
        .ctlm_in(id_ex_mem),
        .regdst(id_ex_regdst),
        .alusrc(id_ex_alusrc),
        .alu_op(id_ex_aluop),

        .npc(id_ex_npc),
        .rdata1(id_ex_readdat1),
        .rdata2(id_ex_readdat2),
        .s_extend(id_ex_sign_ext),

        .instr_2016(id_ex_instr_bits_20_16),
        .instr_1511(id_ex_instr_bits_15_11),

        // lower 6 bits are used as the function field for r-type
        .funct(id_ex_sign_ext[5:0]),

        .ctlwb_out(ex_mem_wb),
        .memread_out(ex_mem_memread),
        .memwrite_out(ex_mem_memwrite),
        .membranch_out(ex_mem_membranch),

        .adder_out(ex_mem_adder_result),
        .zero(ex_mem_zero),
        .alu_result_out(ex_mem_alu_result),
        .rdata2_out(ex_mem_readdat2),
        .muxout_out(ex_mem_write_reg)
    );


    // -------------------------
    // memory/writeback stage
    // -------------------------

    mem mem0(
        .clk(clk),
        .rst(rst),

        .wb_ctlout(ex_mem_wb),
        .branch(ex_mem_membranch),
        .memread(ex_mem_memread),
        .memwrite(ex_mem_memwrite),

        .zero(ex_mem_zero),
        .alu_result(ex_mem_alu_result),
        .rdata2out(ex_mem_readdat2),
        .five_bit_muxout(ex_mem_write_reg),

        .mem_pcsrc(mem_pcsrc),

        .mem_wb_regwrite(mem_wb_regwrite),
        .mem_wb_memtoreg(mem_wb_memtoreg),
        .read_data(mem_read_data),
        .mem_alu_result(mem_alu_result),
        .write_data(write_data),
        .mem_write_reg(mem_write_reg)
    );


    // -------------------------
    // waveform outputs
    // -------------------------

    // these are only here so the important values are easier to view
    assign instr_out         = if_id_instr;
    assign npc_out           = if_id_npc;
    assign read_data1_out    = id_ex_readdat1;
    assign read_data2_out    = id_ex_readdat2;
    assign alu_result_out    = ex_mem_alu_result;
    assign mem_read_data_out = mem_read_data;
    assign write_data_out    = write_data;
    assign write_reg_out     = mem_write_reg;
    assign regwrite_out      = mem_wb_regwrite;
    assign memtoreg_out      = mem_wb_memtoreg;
    assign pcsrc_out         = mem_pcsrc;

endmodule