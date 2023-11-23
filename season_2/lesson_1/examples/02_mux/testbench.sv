module testbench;

    logic a;
    logic b;
    logic sel;
    logic c;

    mux DUT(
        .a   ( a   ),
        .b   ( b   ),
        .sel ( sel ),
        .c   ( c   )
    );

    initial begin

        a   = 0;
        b   = 1;
        sel = 1;

        #20ns;
        if(c !== 1) $error("BAD");
        $stop();

    end

endmodule
