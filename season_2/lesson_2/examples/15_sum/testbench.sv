module testbench;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    // Остальные сигналы
    logic [7:0] A;
    logic [7:0] B;
    logic [7:0] C;

    sum DUT(
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
        repeat(1000) begin
            @(posedge clk);
            A <= $urandom_range(0, 10);
            B <= $urandom_range(0, 10);
        end
        @(posedge clk);
        $stop();
    end

    typedef struct {
        logic [7:0] a;
        logic [7:0] b;
        logic [7:0] c;
    } packet;

    mailbox#(packet) mon2chk = new();

    // Мониторинг
    initial begin
        packet pkt;
        wait(aresetn);
        forever begin
            @(posedge clk);
            pkt.a = A;
            pkt.b = B;
            pkt.c = C;
            mon2chk.put(pkt);
        end
    end

    // Проверка выходных сигналов
    initial begin
        packet pkt_prev, pkt_cur;
        wait(aresetn);
        mon2chk.get(pkt_prev);
        forever begin
            mon2chk.get(pkt_cur);
            if( pkt_cur.c !=  pkt_prev.a + pkt_prev.b)
                $error("BAD");
            pkt_prev = pkt_cur;
        end
    end

endmodule
