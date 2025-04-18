module testbench;


    // Пример класса для верификации делителя.
    // 
    // TODO:              
    //                                     
    //  Создайте поля:                                   
    //    - bit [31:0] divident;                         
    //    - bit [ 7:0] divider;                          
    //                                                   
    //  Опишите ограничения такие, что:                  
    //    1) ~divident~ больше 0;                         
    //    2) ~divident~ делится на ~divider~ без остатка;
    //    3) ~divident~ больше ~divider~.                

    class my_class_1;

    endclass


    // Пример класса для обращения по адресу.          
    //
    // TODO: 
    //                                                  
    // Создайте поля:                                   
    //   - logic [31:0] data;                           
    //   - logic [ 7:0] addr;                           
    //                                                  
    // Опишите ограничения такие, что:                  
    //   1) если ~data~ равен нулю, то ~addr~ равен 128;
    //   2) ~data~ является степенью 2 либо равно 0;                 
    //   3) ~addr~ меньше 64.                           

    class my_class_2;

    endclass


    // Пример рандомизации массива с особыми ограничениями.   
    //
    // TODO:
    //                                                        
    // Создайте поля:                                         
    //   - int data [];                                       
    //                                                        
    // Опишите ограничения такие, что:                        
    //   1) размер массива четный;                            
    //   2) размер массива меньше 10 и больше 0;              
    //   3) каждый элемент массива меньше 200;                
    //   4) если индекс элемента четный - элемент тоже четный.

    class my_class_3;

    endclass


    // Пример рандомизации массива с рандомизацией его размера  
    // через отдельное поле.                                    
    //
    // TODO:
    //                                                          
    // Создайте поля:                                           
    //   - bit [1:0] size;                                      
    //   - bit [7:0] data [];                                   
    //                                                          
    // Опишите ограничения такие, что:                          
    //   1) размер 'data' равен 'size';                         
    //   2) 'size' больше 0;                                    
    //   2) если 'size' равен 3, то все элементы 'data' равны 0,
    //      иначе каждый элемент 'data' уникален;               

    class my_class_4;

    endclass


    // Пример класса для верификации памяти.       
    //
    // TODO:                    
    //                                                                 
    // Создайте поля:                                                  
    //   - bit [7:0] data;                                             
    //   - bit [7:0] addr;                                             
    //   - bit req;                                                    
    //   - bit we;                                                     
    //                                                                 
    // Опишите ограничения такие, что:                                 
    //   1) адрес выровнен по границе байта (последние 2 бита равны 0);
    //   2) если 'req' равен 1, то 'data' в интервале от 128 до 200;   
    //   3) если 'req' и 'we' равны 1, то 'addr' меньше 128.           

    class my_class_5;

    endclass


    // Пример класса пакета для AMBA AXI-Stream.      
    //
    // TODO:
    //                                                
    // Создайте поля:                                 
    //   - bit [31:0] tdata [];                       
    //   - bit        tid;                            
    //   - bit        tlast [];                       
    //                                                
    // Опишите ограничения такие, что:                
    //   1) размер 'tdata' равен размеру 'tlast';     
    //   2) размеры 'tdata' и 'tlast' больше 0 и не больше 32;   
    //   3) размеры 'tdata' и 'tlast' кратны 8;       
    //   4) 'tlast', равный 1, появляется в массиве не
    //      чаще, чем раз в 4 значения.               

    class my_class_6;

    endclass

    `include "checker.svh"

endmodule
