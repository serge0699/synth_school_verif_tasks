module requester (
    input  logic clk,
    input  logic ready,
    output logic request
);

    // request
    initial begin
        request <= 0;
        @(posedge clk);
        forever begin
            while(!ready) @(posedge clk);
            repeat($urandom_range(5, 15)) @(posedge clk);
            request <= 1;
            @(posedge clk);
            request <= 0;
        end
    end

endmodule