module testbench;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    // Остальные сигналы
    logic [7:0] A;
    logic [7:0] B;
    logic       C;

    comp DUT(
        .clk     ( clk     ),
        .aresetn ( aresetn ),
        .a       ( A       ),
        .b       ( B       ),
        .c       ( C       )
    );

    // Период тактового сигнала
    parameter CLK_PERIOD = 10;

    // Генерация тактового сигнала
    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end

    // Генерация сигнала сброса
    initial begin
        aresetn <= 0;
        #(CLK_PERIOD);
        aresetn <= 1;
    end

    // Генерация входных сигналов
    initial begin
        wait(aresetn);
        @(posedge clk);
        A <= 2;
        B <= 3;
        @(posedge clk);
        A <= 30;
        B <= 20;
    end

    // Проверка выходных сигналов
    initial begin
        wait(aresetn);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        if( C !== 0 ) $error("BAD");
        @(posedge clk);
        if( C !== 1 ) $error("BAD");
        $stop();
    end

endmodule
