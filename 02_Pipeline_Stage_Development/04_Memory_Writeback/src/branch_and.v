/*
This bit-wise ANDs the branch and zero, indicating if a jump to an address is necessary.
The ouptut, PCSrc, goes to mux.v from the Fetch Stage.
If PCSrc is true (1), then there is a branch jump.
Otherwise, if PCSrc is false (0), then there is no branch jump.
*/

module branch_and(
input wire membranch, zero,
output wire PCSrc
);

assign PCSrc = membranch & zero;

endmodule