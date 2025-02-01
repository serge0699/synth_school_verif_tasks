module testbench;

    class base;
        rand bit [7:0] addr;
        function void print();
            $display("Base!");
        endfunction
    endclass

    class child extends base;
        function void print();
            super.print();
            $display("Child!");
        endfunction
    endclass

    child c; // Handle

    initial begin
        c = new();
        c.print();
    end

endmodule