# Pipeline Optimization — Instruction Scheduling

The final optimization did **not** add forwarding hardware.

The original instruction sequence relied on NOPs to separate dependent instructions. The optimized version kept the processor hardware unchanged and reorganized instruction memory so safe independent instructions could occupy some of those otherwise wasted cycles.

This is an instruction-scheduling/code-reordering optimization.

Forwarding, hazard-detection hardware, and Tomasulo-style dynamic scheduling were studied as more advanced alternatives, but they were not implemented in this final optimization.
