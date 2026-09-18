module regfile(
    input wire         clk,
                       rst,
                       regwrite,
    input wire [4:0]   rs,
                       rt,
                       rd,

    input wire [31:0]  writedata,
    output reg [31:0]  A_readdat1,
                       B_readdat2
);

    // COMPLETE:
    // Create an internal regfile called REG that is 32 bit regs with 32 addressable locations (32 x 32)
    // Refer to instruction memory on how to create a regfile (2-dimensional array)
    reg [31:0] REG [31:0];

    integer i;

    initial begin
        // COMPLETE: Initialize all registers to 0
        for (i = 0; i < 32; i = i + 1) begin
            REG[i] = 32'b0;
        end

        A_readdat1 = 32'b0;
        B_readdat2 = 32'b0;
    end


    // write into the register file on the clock edge
    always @(posedge clk) begin
        if (rst) begin
            // reset all registers back to 0
            for (i = 0; i < 32; i = i + 1) begin
                REG[i] <= 32'b0;
            end
        end
        else begin
            if (regwrite && rd != 5'd0) begin
                // COMPLETE
                // Overwrite the value location rd within REG with writedata
                REG[rd] <= writedata;
            end

            // keep register 0 at 0 because the program uses r0 as zero
            REG[0] <= 32'b0;
        end
    end


    // read from the register file
    always @(*) begin
        if (rst) begin
            // COMPLETE
            // Set A_readdat1 and B_readdat2 to 32 bits of 0's
            A_readdat1 = 32'b0;
            B_readdat2 = 32'b0;
        end
        else begin
            // COMPLETE
            // Set A_readdat1 to the value at location rs within REG
            // If the register is being written back in the same cycle, use writedata
            if (regwrite && rd == rs && rd != 5'd0) begin
                A_readdat1 = writedata;
            end
            else begin
                A_readdat1 = REG[rs];
            end

            // COMPLETE
            // Set B_readdat2 to the value at location rt within REG
            // If the register is being written back in the same cycle, use writedata
            if (regwrite && rd == rt && rd != 5'd0) begin
                B_readdat2 = writedata;
            end
            else begin
                B_readdat2 = REG[rt];
            end
        end
    end

endmodule