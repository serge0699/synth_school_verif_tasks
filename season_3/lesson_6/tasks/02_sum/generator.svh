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
    event done;
    initial begin
        wait(aresetn);
        @(posedge clk);
        a <= 1;
        b <= 0;
        for(int i = 101; i < 254; i = i + 1) begin
            if( i[0] ) begin
                @(posedge clk);
                a <= i;
                b <= i + 1;
            end
        end
        for(int i = 50; i < 100; i = i + 1 ) begin
            @(posedge clk);
            a <= i;
            b <= i - 50;
        end
        @(posedge clk);
        ->> done;
    end