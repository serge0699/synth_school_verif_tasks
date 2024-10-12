`timescale 1ns/1ps

module testbench;

    logic [7:0] a;
    logic [7:0] b;
    logic [7:0] c;

    sum DUT(
        .a ( a ),
        .b ( b ),
        .c ( c )
    );

    event ev;

    initial begin

        a = 'x; b = 'x;
        #1; ->> ev;

        #9;
        b = 2;
        #1; ->> ev;

        #9;
        a = 1;
        #1; ->> ev;

        #9;
        a = 5;
        #1; ->> ev;

        #9;
        $stop();

    end

    initial begin
        while(1) begin
            @ev;
            if( c !== a + b ) $error("BAD");
        end
    end

endmodule