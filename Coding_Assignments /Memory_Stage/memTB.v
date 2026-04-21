// memoryTB.v

module memoryTB();

    reg clk;
    reg [31:0] alu_result, rdata2out;
    reg [4:0] five_bit_muxout;
    reg [1:0] wb_ctlout;
    reg memwrite, memread, branch, zero;

    wire MEM_PCSrc;
    wire MEM_WB_regwrite, MEM_WB_memtoreg;
    wire [31:0] read_data, mem_alu_result;
    wire [4:0] mem_write_reg;

    mem uut(
        .clk(clk),
        .wb_ctlout(wb_ctlout),
        .branch(branch),
        .memread(memread),
        .memwrite(memwrite),
        .zero(zero),
        .alu_result(alu_result),
        .rdata2out(rdata2out),
        .five_bit_muxout(five_bit_muxout),
        .MEM_PCSrc(MEM_PCSrc),
        .MEM_WB_regwrite(MEM_WB_regwrite),
        .MEM_WB_memtoreg(MEM_WB_memtoreg),
        .read_data(read_data),
        .mem_alu_result(mem_alu_result),
        .mem_write_reg(mem_write_reg)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // starting everything at 0 first
        alu_result = 0;
        rdata2out = 0;
        five_bit_muxout = 0;
        wb_ctlout = 0;
        memwrite = 0;
        memread = 0;
        branch = 0;
        zero = 0;

        // case 1
        // this is checking a memory read
        // data.txt loads DMEM[4] = 4, so reading address 4 should give back 4
        alu_result = 32'd4;
        rdata2out = 32'd0;
        five_bit_muxout = 5'd2;
        wb_ctlout = 2'b11;
        memwrite = 0;
        memread = 1;
        branch = 0;
        zero = 0;
        #10;

        // case 2
        // now this is checking a memory write
        // write 20 into address 4
        alu_result = 32'd4;
        rdata2out = 32'd20;
        five_bit_muxout = 5'd2;
        wb_ctlout = 2'b00;
        memwrite = 1;
        memread = 0;
        branch = 0;
        zero = 0;
        #10;

        // case 3
        // read address 4 again
        // if the write worked, this should now come back as 20 instead of 4
        alu_result = 32'd4;
        rdata2out = 32'd0;
        five_bit_muxout = 5'd2;
        wb_ctlout = 2'b11;
        memwrite = 0;
        memread = 1;
        branch = 0;
        zero = 0;
        #10;

        // case 4
        // checking the branch logic
        // branch = 1 and zero = 1 means PCSrc should go high
        branch = 1;
        zero = 1;
        memwrite = 0;
        memread = 0;
        #10;

        $finish;
    end

endmodule