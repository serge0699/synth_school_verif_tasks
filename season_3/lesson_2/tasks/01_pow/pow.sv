module pow (
    input  logic        clk,
    input  logic [31:0] a,
    output logic [31:0] b
);

    always_ff @(posedge clk) begin
        b <= a * a;
    end

endmodule