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
        $display($urandom());
        $display($urandom());
        $display($urandom());
        $stop();
    end

endmodule
