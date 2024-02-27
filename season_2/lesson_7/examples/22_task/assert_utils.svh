`define ASSERT_WITH(PROP) \
    a``PROP: assert property(PROP) begin \
        $display("Good %m!"); \
        $stop(); \
    end else begin \
        $display("Bad %m!"); \
        $stop(); \
    end