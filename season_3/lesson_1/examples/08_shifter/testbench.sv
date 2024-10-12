`timescale 1ns/1ps;

module testbench;

    logic [7:0] a;
    logic [2:0] b;
    logic [7:0] c;

    shifter DUT(
        .a ( a ),
        .b ( b ),
        .c ( c )
    );

    event ev;

    initial begin

        a = 'x; b = 'x;
        #1; ->> ev;

        #9;
        a = 8'b0001; b = 3'd7;
        #1; ->> ev;

        #9;
        b = 3'd3;
        #1; ->> ev;

        #9;
        b = 3'd1;
        #1; ->> ev;

        #9;
        a = 8'b1000; b = 3'd7;
        #1; ->> ev;

        #9;
        b = 3'd3;
        #1; ->> ev;

        #9;
        $stop();

    end

    initial begin
        while(1) begin
            @ev;
            if( c !== a << b ) $error("BAD");
        end
    end

endmodule
