module testbench;

    class base1;
        rand bit [1:0] a;
        rand bit [1:0] b;
        constraint a_c { a > 1; }
        constraint b_c { b < 2; }
    endclass

    initial begin
        base1 b1;
        b1 = new();
        b1.randomize() with {a + b > 2;};
        $display("b1.a: %0d, b1.b: %0d",
            b1.a, b1.b);
    end

endmodule

