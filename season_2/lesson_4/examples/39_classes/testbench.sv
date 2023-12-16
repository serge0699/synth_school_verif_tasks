module testbench;

    class base;
        local     rand bit  [7:0] addr;
        protected rand bit [31:0] data;
                  rand bit        id;
    endclass

    class child extends base;
        function void print_protected();
            $display(data);
        endfunction
        function void print_local();
            $display(addr);
        endfunction
        function void print_public();
            $display(addr);
        endfunction
    endclass

    child c; // Handle

    initial begin
        c = new();
        c.print_protected();
        c.print_local();
        $display(c.data); // protected
        $display(c.addr); // local
        $display(c.addr); // public
    end

endmodule