module inv (
    input  logic clk,
    input  logic signal_in,
    output logic signal_out
);

    always_ff @( posedge clk ) begin
        signal_out <= ~signal_in;
    end

endmodule