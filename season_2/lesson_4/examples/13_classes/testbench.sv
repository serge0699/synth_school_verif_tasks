module testbench;

    class base1;
        rand  bit [1:0] a;
    endclass 

    base1 b1;
    initial begin
        b1 = new();
        b1.a.rand_mode(0);
        for(int i = 0; i < 5; i = i + 1) begin
            if( i == 3 ) b1.a.rand_mode(1);
            b1.randomize();
            $display("b1.a: %0d", b1.a);
        end
    end

endmodule
