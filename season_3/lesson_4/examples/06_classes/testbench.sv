module testbench;

    class base1;
        bit [7:0] a;
        // function new();
        // endfunction
    endclass

    base1 b1; // Handle

    initial begin
        $display(b1); // null
    end

endmodule
