module comp (
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic       c
);

    assign c = a > b;

endmodule