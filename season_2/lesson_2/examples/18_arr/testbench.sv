module testbench;

    // Массив
    int arr [];

    int iters;

    // Генерация через $urandom
    initial begin
        int idx;
        void'($value$plusargs("iters=%0d", iters));
        repeat(iters) begin
            idx = $urandom_range(20, 30);                    // Размер от 20 до 30
            arr = new[idx];
            foreach(arr[i]) begin
                do begin
                    arr[i] = $urandom_range(0, 1024);        // От 0 до 1024
                end
                while ( !(
                    arr[i][5] == 0  &&                       // Пятый бит 0
                    arr[i] % 7 == 0 &&                       // Делится на 7
                    (i % 2 == 0 && arr[i] % 2 == 0) || i % 2 // Если номер элемента четный,
                                                             // то элемент четный
                ) );
            end
        end
    end

endmodule
