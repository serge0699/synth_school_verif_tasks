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
    class packet;
        randc logic [7:0] a;
        randc logic [7:0] b;
    endclass

    task automatic gen_packets(packet p, int num);
        int unsigned idxs [4];
        void'(std::randomize(idxs) with {
            foreach(idxs[i]) {idxs[i] < 256;}
            idxs[0] < idxs[1]; idxs[1] < idxs[2]; idxs[2] < idxs[3];
            idxs[1] - idxs[0] > 40;
            idxs[3] - idxs[2] > 70;
        });
        if($test$plusargs("DEBUG")) $display("%p", idxs);
        repeat(num) begin
            @(posedge clk);
            void'(p.randomize() with {
                a inside {[idxs[0]:idxs[1]]}; b inside {[idxs[2]:idxs[3]]};
            });
            a <= p.a;
            b <= p.b;
        end
    endtask

    initial begin
        packet p;
        wait(aresetn);
        p = new();
        gen_packets(p, 1000);
        $finish();
    end