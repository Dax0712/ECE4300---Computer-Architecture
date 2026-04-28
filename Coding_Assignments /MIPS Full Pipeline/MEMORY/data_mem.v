/*
Instantiates and serves as the data memory of the MIPS processor.
The output, read_data, goes to the MEM/WB latch.
If memread is true, then read_data is re-assigned as the value in the current address.
If memwrite is true, then read_data is unaltered, and instead, the value in the current
address is changed to write_data.

This module is used to:
read from memory for a lw
or write into memory for a sw
*/

module data_memory(
    input wire clk,
    input wire [31:0] addr, // Memory address
    input wire [31:0] write_data, // Data to be written into memory
    input wire memread, memwrite, // Refer to Lab 2-2 Figure 2.2
    output reg [31:0] read_data // Data read from memory
);

// Register Declaration
reg [31:0] DMEM[0:15]; // Creates an array with 256 words of 32-bit memory
integer i;

initial begin
    read_data = 0;

    // Initialize DMEM[0-5] from data.mem
    // This is testing the MIPS datapath (lab 6)
    $readmemb("data.mem", DMEM);

//    for (i = 0; i < 6; i = i + 1)
//        $display("\tDMEM[%0d] = %0b", i, DMEM[i]);

    /* // Initialize DMEM[6-255] to 6-255 (this is for lab 4 memory stage)
    for (i = 6; i < 256; i = i + 1)
        DMEM[i] = i;

    // Display DMEM[0-5]
    $display("From Data Memory (data.txt):");
    for (i = 0; i < 6; i = i + 1)
        $display("\tDMEM[%0d] = %0h", i, DMEM[i]);

    // Display DMEM[6-9]
    $display("From Data Memory (initial):");
    for (i = 6; i < 10; i = i + 1)
        $display("\tDMEM[%0d] = %0d", i, DMEM[i]);

    // Display DMEM[255]
    $display("\t...");
    $display("\tDMEM[%0d] = %0d", 255, DMEM[255]);
    */
end

// Read path
always @(*) begin
    if (memread)
        read_data = DMEM[addr[3:0]];
    else
        read_data = 32'b0;
end

// Write path
always @(posedge clk) begin
    if (memwrite)
        DMEM[addr[3:0]] <= write_data;
end

endmodule