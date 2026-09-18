module incrementer(
    input wire        clk,
    input wire        rst,
    input wire [31:0] pc_in,
    output wire [31:0] pc_out
);

// +1 because the professor's simplified instruction memory uses word indexes
assign pc_out = pc_in + 32'd1;

endmodule