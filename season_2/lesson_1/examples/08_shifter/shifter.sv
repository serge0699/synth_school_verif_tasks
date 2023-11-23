module shifter (
    input  logic [7:0] a,
    input  logic [2:0] b,
    output logic [7:0] c
);

    always_comb begin
        c = a << b;
    end

endmodule
