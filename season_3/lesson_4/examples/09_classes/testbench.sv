module testbench;

    class base1;
        rand bit [7:0] a;
    endclass 

    base1 b1;
    initial begin
        b1 = new();
        repeat(5) begin
            b1.randomize();
            $display(b1.a);
        end
    end

endmodule

