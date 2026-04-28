/*
This bit-wise ANDs the branch and zero, indicating if a branch to an address is necessary.
The output, pcsrc, goes to mux.v from the Fetch Stage.
If pcsrc is true (1), then there is a branch jump.
Otherwise, if pcsrc is false (0), then there is no branch jump.
*/

module branch_and(
    input wire membranch,
    input wire zero,
    output wire pcsrc
);

assign pcsrc = membranch & zero;

endmodule