/*
This mux selects the value that will be written back to the register file.
If memtoreg is 1, then the value from memory is selected.
If memtoreg is 0, then the value from the ALU is selected.
*/

module wb_mux(
    input wire memtoreg,
    input wire [31:0] read_data,
    input wire [31:0] mem_alu_result,
    output wire [31:0] write_data
);

assign write_data = (memtoreg) ? read_data : mem_alu_result;

endmodule