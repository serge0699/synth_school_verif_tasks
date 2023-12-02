module testbench;

    // Массив
    int arr [];

    int iters;

    // Генерация через std::randomize()
    initial begin
        void'($value$plusargs("iters=%0d", iters));
        repeat(iters) begin
            if( !std::randomize(arr) with {
                arr.size() inside {[20:30]};  // Размер от 20 до 30
                foreach( arr[i] ) {           // Для каждого элемента
                    arr[i] inside {[0:1024]}; // От 0 до 1024
                    arr[i][5] == 0;           // Пятый бит 0
                    arr[i] % 5 == 0;          // Делится на 5
                    arr[i] % 6 == 0;          // Делится на 6
                    arr[i] % 7 == 0;          // Делится на 7
                    arr[i] % 8 == 0;          // Делится на 8
                    if( i % 2 == 0 ) {        // Если номер элемента четный,
                        arr[i] % 2 == 0;      // то элемент четный
                    }
                }
            } ) $error("Can't randomize array!");
        end
    end

endmodule
