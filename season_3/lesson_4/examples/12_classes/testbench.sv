module testbench;

    class base1;
        rand  bit [1:0] a;
    endclass 

    base1 b1;
    initial begin
        b1 = new();
        b1.a.rand_mode(0);
        repeat(5) begin
            b1.randomize();
            $display("b1.a: %0d", b1.a);
        end
    end

endmodule

