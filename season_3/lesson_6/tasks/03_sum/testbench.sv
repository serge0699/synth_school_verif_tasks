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
        // Добавьте недостающие входные воздействия здесь.
        // ...
        
        @(posedge clk);
        ->> user_done;
    end

    // TODO:
    // Анализируйте эту модель.
    // Особое внимание уделите перекрестному покрытию.
    covergroup sum_cg @(posedge clk);

        // Обычные coverpoint.

        // Интервалы для a (массивы).
        a_i_cp: coverpoint a {
            bins low  [] = {[0:63]};
            bins mid  [] = {[64:171]};
            bins high [] = {[172:255]};
        }

        // Интервалы для а (единичное попадание дает 100%).
        a_in_cp: coverpoint a {
            bins low  = {[0:63]};
            bins mid  = {[64:171]};
            bins high = {[172:255]};
        }

        // Интервалы для b.
        b_i_cp: coverpoint b {
            bins low  [] = {[0:63]};
            bins mid  [] = {[64:171]};
            bins high [] = {[172:255]};
        }

        // Специалльные значения для a.
        a_s_cp: coverpoint a {
            bins one       = {1};
            bins magics [] = {1, 9, 180};
            bins zero      = {0};
            bins max       = {255};
        }

        // Специальные значения для b.
        b_s_cp: coverpoint b {
            bins one  = {1};
            bins zero = {0};
            bins max  = {255};
        }

        // Перекрестное покрытие.

        // Этот cross создает пересечение всех bins из a_s_cp и a_s_cp.
        cross_1: cross a_s_cp, b_i_cp {
            // Этот фильтр исключает (ignore) все пересечения, в которых есть b - low и b - high.
            ignore_bins a_l_h = binsof(b_i_cp.low) || binsof(b_i_cp.high);
            // А что исключает этот?
            ignore_bins a_m_b_m = binsof(a_s_cp.one);
            // А этот?
            ignore_bins a_mag_b_m = binsof(a_s_cp.magics) && binsof(b_i_cp.mid);
        }

        // Этот cross создает пересечение всех bins из a_i_cp и b_s_cp.
        cross_2: cross a_i_cp, b_s_cp {
            // Этот фильтр исключает все пересечения, в которых есть a - low и a - mid.
            ignore_bins a_low_high = binsof(a_i_cp.low) || binsof(a_i_cp.mid);
            // А что исключает этот?
            ignore_bins a_mid_b_low = binsof(a_i_cp.high) && binsof(b_s_cp.max);
        }

        // Этот cross создает пересечение всех bins из a_i_cp и b_s_cp.
        cross_3: cross a_s_cp, b_s_cp {
            // Такой фильтр означает, что в пересечении участвуют только bins, которые привязаны к 1.
            bins ones     = binsof(a_s_cp.one) && binsof(b_s_cp.one);
            // А такой фильтр выбирает два варианта: a - 0 и b - max, a - max и b - 0
            // Для удобства восприятия разбит на 2 строки
            bins zero_max = binsof(a_s_cp.zero) && binsof(b_s_cp.max ) ||
                            binsof(a_s_cp.max ) && binsof(b_s_cp.zero);
            // А что выбирает такой фильтр?
            bins two_max  = binsof(a_s_cp.max ) && binsof(b_s_cp.max);
            // А что исключает этот?
            ignore_bins max_one = binsof(a_s_cp.max ) && binsof(b_s_cp.one);
        }

        // Да, тройное перекрестное покрытие тоже возможно.
        // Этот cross создает пересечение всех bins из a_in_cp, a_s_cp и b_s_cp.
        // Попробуйте разобраться (GUI в помощь).
        cross_4: cross a_in_cp, a_s_cp, b_s_cp{
            ignore_bins a_magics_zero = binsof(a_s_cp.magics) || binsof(a_s_cp.zero);
            ignore_bins a_low         = binsof(a_in_cp.mid);
            ignore_bins b_one_zero    = binsof(b_s_cp.one);
            ignore_bins a_high_one    = binsof(a_in_cp.high) && binsof(a_s_cp.one);
            ignore_bins a_low_max     = binsof(a_in_cp.low) && binsof(a_s_cp.max);
        }
    endgroup

    sum_cg cg = new();

endmodule
