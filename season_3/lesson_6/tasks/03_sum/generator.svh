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
    event done, user_done; int cnt;
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
        for(int i = 64; i < 172; i = i + 1 ) begin
            @(posedge clk);
            a <= 0;
            b <= i;
        end
        for(int i = 172; i < 256; i = i + 1 ) begin
            @(posedge clk);
            a <= i;
            b <= 1;
        end
        @(posedge clk);
        a <= 1;
        b <= 255;
        @(posedge clk);
        ->> done;
        fork
            forever begin
                @(posedge clk);
                cnt += 1;
            end
            @(user_done);
        join_any
        $display("----------------------------------",    );
        $display("Cycles for user stimulus: %0d     ", cnt);
        $display("----------------------------------",    );
        $finish();
    end