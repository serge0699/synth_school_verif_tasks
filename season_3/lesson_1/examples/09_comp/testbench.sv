`timescale 1ns/1ps;

module testbench;

    logic [7:0] a;
    logic [7:0] b;
    logic       c;

    comp DUT(
        .a ( a ),
        .b ( b ),
        .c ( c )
    );

    event ev;

    initial begin
        a = 'x; b = 'x;
        #1; ->> ev;

        #9;
        a = 10; b = 15; 
        #1; ->> ev;

        #9;
        a = 20;
        #1; ->> ev;

        #9;
        b = 35;
        #1; ->> ev;

        #9;
        $stop();
    end

    initial begin
        while(1) begin
            @ev;
            if( c !== a > b) $error("BAD");
        end
    end

endmodule
