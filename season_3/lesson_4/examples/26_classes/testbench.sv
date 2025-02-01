module testbench;

    class base1;
        rand bit        s;
        rand bit [31:0] d;
        constraint c { s -> d == 0; }
    endclass

    initial begin
        base1 b1;
        b1 = new();
        repeat(100) begin
          b1.randomize();
          $display("b1.s: %1b, b1.d:%8h",
            b1.s, b1.d);
        end
    end

endmodule

