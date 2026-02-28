module testbench;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    // Остальные сигналы
    logic [7:0] A;
    logic [7:0] B;
    logic [7:0] C;

    sum DUT (
        .clk     ( clk     ),
        .aresetn ( aresetn ),
        .a       ( A       ),
        .b       ( B       ),
        .c       ( C       )
    );

    // TODO:
    // Определите период тактового сигнала
    parameter CLK_PERIOD = 10;

    // TODO:
    // Cгенерируйте тактовый сигнал
    initial begin
        clk <= 0;
        forever begin
            // Пишите тут.
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end
    
    // Генерация сигнала сброса
    initial begin
        aresetn <= 0;
        #(CLK_PERIOD);
        aresetn <= 1;
    end

    // TODO:
    // Cгенерируйте входные воздействия и проверки
    // в соответствии с диаграммой.

    //                |10ns-|
    //           __   |__   |__    __    __    __    __    
    // clk     _|  |__|  |__|  |__|  |__|  |__|  |__|  |__|
    //              __|_____|_____|_____|_____|_____|_____|
    // aresetn ____|  |     |     |     |     |     |     |
    //                |     |     |     |     |     |     |
    // A       <XXXXX>|<2-->|<20--+---->|<4-->|<40->|<2---|
    // B       <XXXXX>|<3-->|<30--+---->|<5-->|<50->|<1---|
    // C       <0---->|<XXX>|<5-->|<50--+---->|<9-->|<90--|
    //                |     |     |     |
    //               15ns  25ns  35ns  45ns ...

    initial begin
        // Входные воздействия опишите здесь.
        // Не забудьте про ожидание сигнала сброса!
        wait(aresetn);
        @(posedge clk);
        A <= 2;
        B <= 3;
        @(posedge clk);
        A <= 20;
        B <= 30;
        @(posedge clk);
        @(posedge clk);
        A <= 4;
        B <= 5;
        @(posedge clk);
        A <= 40;
        B <= 50;
        @(posedge clk);
        A <= 2;
        B <= 1;
        @(posedge clk);
        $stop();
    end

    initial begin
        // Проверки опишите здесь.
        // Не забудьте про ожидание сигнала сброса!
        wait(aresetn);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        if( C !== 5 ) $error("BAD");
        @(posedge clk);
        if( C !== 50 ) $error("BAD");
        @(posedge clk);
        if( C !== 50 ) $error("BAD");
        @(posedge clk);
        if( C !== 9 ) $error("BAD");
        @(posedge clk);
        if( C !== 90 ) $error("BAD");
    end

endmodule
