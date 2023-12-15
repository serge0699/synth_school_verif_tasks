module testbench;

    class base1;
        rand  bit [1:0] a;
        function void pre_randomize();
            $display("Before randomize(), a = %0d", a);
        endfunction
        function void post_randomize();
            $display("After  randomize(), a = %0d", a);
        endfunction
    endclass 

    base1 b1;
    initial begin
        b1 = new();
        repeat(3) b1.randomize();
    end

endmodule

