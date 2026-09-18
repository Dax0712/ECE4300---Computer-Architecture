# ECE 4300 — Computer Architecture

Coursework and processor-design work from ECE 4300 at California State Polytechnic University, Pomona.

This repository is organized to show the progression of the course: benchmark work, development of individual processor stages, integration into a simplified five-stage MIPS-style pipeline, and a final instruction-scheduling optimization.

> **Architecture note:** The implemented Verilog processor is a simplified MIPS-style pipeline. RISC-V was studied as part of the broader computer-architecture coursework, but this repository does not claim that the Verilog pipeline is a RISC-V processor.

## Repository Map

- [01 — Benchmarks](./01_Benchmarks/)
- [02 — Pipeline Stage Development](./02_Pipeline_Stage_Development/)
- [03 — Integrated MIPS Pipeline](./03_Integrated_MIPS_Pipeline/)
- [04 — Pipeline Optimization](./04_Pipeline_Optimization/)
- [05 — Architecture Study](./05_Architecture_Study/)

## Main Technical Topics

- Instruction-set architecture and hardware/software interaction
- Five-stage pipelining: Fetch, Decode, Execute, Memory, and Writeback
- Verilog RTL and modular datapath construction
- Pipeline registers and control-signal propagation
- ALU, register file, instruction memory, and data memory behavior
- Data hazards, NOPs, instruction scheduling, and forwarding as a studied alternative
- Vivado simulation and waveform-based verification
- Architecture security topics including speculative execution, cache timing, and DRAM disturbance

## Project Progression

The processor was not written as one monolithic assignment. Individual stages were first developed and tested separately. Corrected stage versions were then integrated into the complete pipeline. The final optimization kept the pipeline hardware unchanged and reorganized instruction memory so independent instructions could replace some wasted NOP slots.

Where coursework was completed collaboratively, the original reports and source history preserve collaborator attribution.
