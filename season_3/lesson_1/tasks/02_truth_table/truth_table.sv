module truth_table (
    input  logic a, b, c,
    output logic r
);

    assign r = c | a & ~b | ~a & b;

endmodule