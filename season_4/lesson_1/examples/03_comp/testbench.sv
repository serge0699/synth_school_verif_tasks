module testbench;

    logic [7:0] a;
    logic [7:0] b;
    logic       c;

    comp DUT(
        .a   ( a   ),
        .b   ( b   ),
        .c   ( c   )
    );

    initial begin

        a = 10;
        b = 15;

        #20ns;
        if(c !== 0) $error("BAD");
        $stop();

    end

endmodule
