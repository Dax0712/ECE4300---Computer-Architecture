`timescale 1ns / 1ps
/*
Execute Stage:
    - This uses the outputs of Fetch and Decode as well as combining
    - the modules: adder, bottom_mux(5-bit), alu_control, alu, top_mux(32-bit), and ex_mem
*/

module Execute(
    input wire clk,
    input wire rst,
    input wire [1:0] ctlwb_in, // control signals coming from the ID/EX latch
    input wire [2:0] ctlm_in,
    input wire regdst, alusrc,
    input wire [1:0] alu_op,
    input wire [31:0] npc, rdata1, rdata2, s_extend,
    input wire [4:0] instr_2016, instr_1511,
    input wire [5:0] funct, // this should stem from the 6 lowest bits of the instruction
    output wire [1:0] ctlwb_out,

    // output wire [1:0] ctlm_out needs to be split into 3 output signals
    output wire memread_out,
    output wire memwrite_out,
    output wire membranch_out,

    output wire [31:0] adder_out,
    output wire zero,
    output wire [31:0] alu_result_out, rdata2_out,
    output wire [4:0] muxout_out
);

//signals
wire [31:0] adder_result_in;// internal wire to connect adder output to the EX/MEM latch
wire [31:0] alu_b;          // internal wire to connect top_mux output to the ALU
wire [31:0] aluout;         // internal wire to connect the ALU result to the EX/MEM latch
wire [4:0] muxout;          // internal wire to connect the 5-bit mux to the EX/MEM latch
wire [2:0] control;         // internal wire to connect the ALU control to the ALU
wire aluzero;               // internal wire to connect the ALU zero output to the EX/MEM latch

// MODULE INSTANTIATIONS
//====================================================================================================

/*
>> what is adder for? What is the purpose of this?
This is for calculating the branch target address.
It takes the current PC (npc) and adds the sign-extended immediate value (s_extend)
to it to get the target address for a branch instruction. This is used in the MEM stage to determine
if a branch should be taken and what the target address is.
*/

adder adder3(
    .add_in1(npc),
    .add_in2(s_extend),
    .add_out(adder_result_in)
);
// Essentially and intuitively means:
// adder_result_in = npc + s_extend

//====================================================================================================

/*
>> what is bottom_mux for? What is the purpose of this?
This is for selecting the destination register for the write-back stage
*/

bottom_mux bottom_mux3(
    .a(instr_1511), // rd field
    .b(instr_2016), // rt field
    .sel(regdst),
    .y(muxout)
);
// Essentially and intuitively means:
// if regdst == 0, then muxout = instr_2016 (rt field)
// if regdst == 1, then muxout = instr_1511 (rd field)

//====================================================================================================

/*
>> what is alu_control for? What is the purpose of this?
This is for generating the control signals for the ALU based on the funct field
of the instruction and the ALUOp control signal from the control unit
*/

alu_control alu_control3(
    .funct(funct),   // this should be the low 6 bits of the instruction, passed through the ID/EX latch
    .aluop(alu_op),
    .select(control)
);
// Essentially and intuitively means:
// The ALU control logic will take the ALUOp signal and the funct field
// to determine what operation the ALU should perform.

//====================================================================================================

/*
>> what is top_mux for? What is the purpose of this?
This is for selecting the second operand for the ALU.
If alusrc is 0, the second operand is the register data from the register file (rdata2).
If alusrc is 1, the second operand is the sign-extended immediate value (s_extend).
*/

top_mux top_mux3(
    .y(alu_b),      // output of mux is 32-bit "alu_b" wire
    .a(rdata2),     // input a is the second register data from the register file
    .b(s_extend),   // input b is the sign-extended immediate value
    .sel(alusrc)    // control signal that determines whether to use
                    // the immediate value or the register data as the second operand for the ALU
);
// Essentially and intuitively means:
// if alusrc == 0, then alu_b = rdata2 (second register data)
// if alusrc == 1, then alu_b = s_extend (sign-extended immediate value)

//====================================================================================================

/*
>> what is alu for? What is the purpose of this?
This performs the arithmetic or logical operation chosen by alu_control.
It uses rdata1 as the first operand and the output of top_mux as the second operand.
*/

alu alu3(
    .a(rdata1),
    .b(alu_b),
    .control(control),
    .result(aluout),
    .zero(aluzero)
);

//====================================================================================================

/*
>> what is ex_mem for? What is the purpose of this?
This is for storing the outputs of the EX stage and passing them to the MEM stage.
It takes the control signals and data from the EX stage and latches them so that they can be used in the MEM stage.
*/

ex_mem ex_mem3(
    .clk(clk),
    .rst(rst),
    .ctlwb_in(ctlwb_in),
    .ctlm_in(ctlm_in),
    .adder_in(adder_result_in),
    .zero_in(aluzero),
    .alu_in(aluout),
    .readdat2_in(rdata2),
    .mux_in(muxout),
    .ctlwb_out(ctlwb_out),
    // .ctlm_out(ctlm_out),
    .memread_out(memread_out),
    .memwrite_out(memwrite_out),
    .membranch_out(membranch_out),
    
    .adder_out(adder_out),
    .alu_result_out(alu_result_out),
    .zero_out(zero),
    .rdata2_out(rdata2_out),
    .muxout_out(muxout_out)
);
// Essentially and intuitively means:
// The EX/MEM latch takes the outputs from the EX stage
// and latches them on the clock edge so that they can be used in the MEM stage.

endmodule  // end of Execute module