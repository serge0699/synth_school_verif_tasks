module testbench;

    class base1;
        bit [7:0] a;
        function new(bit [7:0] a);
            this.a = a; // a = a ?
        endfunction
    endclass

    base1 b1; // Handle

    initial begin
        b1 = new(7); // b1.a = 7
        $display(b1.a);
    end

endmodule