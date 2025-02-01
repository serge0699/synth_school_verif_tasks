module testbench;

    class base1;
        randc bit [1:0] a;
        rand  bit [1:0] b;
    endclass 

    base1 b1;
    initial begin
        b1 = new();
        repeat(20) begin
            b1.randomize();
            $display("b1.a: %0d", b1.a);
            $display("b1.b: %0d", b1.b);
        end
    end

endmodule

