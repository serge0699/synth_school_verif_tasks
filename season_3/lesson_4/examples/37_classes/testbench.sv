module testbench;

    class base;
        rand bit [7:0] addr;
        constraint addr_c { addr > 10; }
    endclass

    class child extends base;
        rand bit [7:0] data;
        constraint data_c { data < 2; };
    endclass

    child c; // Handle

    initial begin
        c = new();
        repeat(10) begin
            c.randomize();
            $display("c.addr: %0d c.data: %0d",
                c.addr, c.data);
        end
    end

endmodule