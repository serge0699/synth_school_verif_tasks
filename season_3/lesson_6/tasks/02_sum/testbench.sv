module testbench;

    // Тактовый сигнал и сигнал сброса
    logic clk;
    logic aresetn;

    // Остальные сигналы
    logic [7:0] a;
    logic [7:0] b;
    logic [7:0] c;

    sum DUT(
        .clk     ( clk     ),
        .aresetn ( aresetn ),
        .a       ( a       ),
        .b       ( b       ),
        .c       ( c       )
    );

    `include "generator.svh"

    // TODO:
    // В ходе тестирования на порты 'a' и 'b'
    // подаются некоторые значения. Проанализируйте
    // модель покрытия и результаты сбора покрытия
    // (используйте GUI).
    // Добавьте генерацию недостающих входных значений
    // и добейтесь покрытия в 100%.

    initial begin
        @done;
        // TODO:
        // Добавьте недостающие входные воздействия здесь
        // ...
        @(posedge clk);
        $finish();
    end

    // TODO:
    // Анализируйте эту модель
    covergroup sum_cg @(posedge clk);
        a_cp: coverpoint a {
            bins min = {0};
            bins one = {1};
            bins max = {32'hFF};
            bins intervals [16] = {[0:255]};
            bins magic [3] = {111, 177, 49};
            bins even_in_range = {[150:250]} with (item[0] == 0);
        }
        b_cp: coverpoint b {
            bins min = {0};
            bins one = {1};
            bins max = {32'hFF};
            bins intervals [16] = {[0:255]};
            bins magic [3] = {75, 99, 52};
            bins odd_in_range = {[120:130]} with (item[0] == 1);
        }
    endgroup

    sum_cg cg = new();

endmodule
