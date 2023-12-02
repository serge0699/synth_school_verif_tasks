module comp (
    input  logic       clk,
    input  logic       aresetn,
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic       c
);

    always_ff @( posedge clk or negedge aresetn ) begin
        if(!aresetn) c <= 'b0;
        else c <= a > b;
    end

endmodule