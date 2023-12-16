`timescale 1ns/1ps

module testbench;

    logic       clk;
    logic [7:0] A;
    logic [7:0] B;

    class packet;
        rand logic [7:0] a;
        rand logic [7:0] b;
    endclass

    initial begin
        clk <= 0;
        forever #10 clk <= ~clk;
    end

    initial begin
        packet p;
        p = new();
        p = new();
        repeat(10) begin
            @(posedge clk);
            p.randomize();
            A <= p.a;
            B <= p.b;
        end
        $display($urandom());
        $stop();
    end

endmodule
