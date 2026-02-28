module mux (
    input  logic a,
    input  logic b,
    input  logic sel,
    output logic c
);

    assign c = sel ? b : a;

endmodule