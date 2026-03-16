module incrementer(
    input wire        clk,
    input wire        rst,
    input wire [31:0] pc_in,
    output wire [31:0] pc_out
);

// +4 because byte addressed
assign pc_out = pc_in + 32'd4;

endmodule