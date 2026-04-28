/*
Memory Stage: This uses the outputs of Execute Stage as well as combining the modules:
    branch_and, data_memory, mem_wb, and wb_mux.
*/

module mem(
    input wire clk,
    input wire rst,
    input wire [1:0] wb_ctlout,
    input wire branch, memread, memwrite,
    input wire zero,
    input wire [31:0] alu_result, rdata2out,
    input wire [4:0] five_bit_muxout,

    output wire mem_pcsrc, // from branch_and
    output wire mem_wb_regwrite, mem_wb_memtoreg,
    output wire [31:0] read_data, mem_alu_result, write_data,
    output wire [4:0] mem_write_reg
);

// signals
wire [31:0] read_data_in;

// instantiations
branch_and branch_and4(
    .membranch(branch),
    .zero(zero),
    .pcsrc(mem_pcsrc)
);

data_memory data_memory4(
    .clk(clk),
    .addr(alu_result),
    .write_data(rdata2out),
    .memwrite(memwrite),
    .memread(memread),
    .read_data(read_data_in)
);

mem_wb mem_wb4(
    .clk(clk),
    .rst(rst),
    .control_wb_in(wb_ctlout),
    .read_data_in(read_data_in),
    .alu_result_in(alu_result),
    .write_reg_in(five_bit_muxout),
    .regwrite(mem_wb_regwrite),
    .memtoreg(mem_wb_memtoreg),
    .read_data(read_data),
    .mem_alu_result(mem_alu_result),
    .mem_write_reg(mem_write_reg)
);

wb_mux wb_mux4(
    .memtoreg(mem_wb_memtoreg),
    .read_data(read_data),
    .mem_alu_result(mem_alu_result),
    .write_data(write_data)
);

endmodule