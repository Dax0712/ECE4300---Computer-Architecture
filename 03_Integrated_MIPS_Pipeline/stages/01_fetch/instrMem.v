module instrMem(
    input wire        clk,
    input wire        rst,
    input wire [31:0] addr,
    output reg [31:0] data
);

reg [31:0] mem [0:255];

initial begin
    $readmemb("instr.mem", mem);
end

always @(*) begin
    if (addr < 256)
        data = mem[addr[7:0]];
    else
        data = 32'b0;
end

endmodule