/*
This is the latch that receives the signals from all the modules of the memory stage.
Its outputs go to the WRITE-BACK stage.
*/

module mem_wb(
    input wire clk,
    input wire rst,
    input wire [1:0] control_wb_in,
    input wire [31:0] read_data_in,
    input wire [31:0] alu_result_in,
    input wire [4:0] write_reg_in,
    output reg regwrite,
    output reg memtoreg,
    output reg [31:0] read_data,
    output reg [31:0] mem_alu_result,
    output reg [4:0] mem_write_reg
);

/*
initial begin
    regwrite = 0;
    memtoreg = 0;
    read_data = 0;
    mem_alu_result = 0;
    mem_write_reg = 0;
end
*/

always @(posedge clk) begin
    if (rst) begin
        regwrite       <= 1'b0;
        memtoreg       <= 1'b0;
        read_data      <= 32'b0;
        mem_alu_result <= 32'b0;
        mem_write_reg  <= 5'b0;
    end
    else begin
        regwrite       <= control_wb_in[1];
        memtoreg       <= control_wb_in[0];
        read_data      <= read_data_in;
        mem_alu_result <= alu_result_in;
        mem_write_reg  <= write_reg_in;
    end
end

endmodule