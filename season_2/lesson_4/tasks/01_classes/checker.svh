mailbox#(my_class_1) mbx_1 = new();
mailbox#(my_class_2) mbx_2 = new();
mailbox#(my_class_3) mbx_3 = new();
mailbox#(my_class_4) mbx_4 = new();
mailbox#(my_class_5) mbx_5 = new();
mailbox#(my_class_6) mbx_6 = new();

initial begin

    my_class_1 cl_1;
    my_class_2 cl_2;
    my_class_3 cl_3;
    my_class_4 cl_4;
    my_class_5 cl_5;
    my_class_6 cl_6;

    repeat(10000) begin
        cl_1 = new(); 
        if(!cl_1.randomize())
            $error("Can't randomize my_class_1, check constraints!");
        mbx_1.put(cl_1);
        cl_2 = new(); 
        if(!cl_2.randomize())
            $error("Can't randomize my_class_2, check constraints!");
        mbx_2.put(cl_2);
        cl_3 = new(); 
        if(!cl_3.randomize())
            $error("Can't randomize my_class_3, check constraints!");
        mbx_3.put(cl_3);
        cl_4 = new(); 
        if(!cl_4.randomize())
            $error("Can't randomize my_class_4, check constraints!");
        mbx_4.put(cl_4);
        cl_5 = new(); 
        if(!cl_5.randomize())
            $error("Can't randomize my_class_5, check constraints!");
        mbx_5.put(cl_5);
        cl_6 = new(); 
        if(!cl_6.randomize())
            $error("Can't randomize my_class_6, check constraints!");
        mbx_6.put(cl_6);
    end
end

initial begin

    // Data queue for unique check
    bit [7:0] data_queue [$];

    // Class handles
    my_class_1 cl_1;
    my_class_2 cl_2;
    my_class_3 cl_3;
    my_class_4 cl_4;
    my_class_5 cl_5;
    my_class_6 cl_6;

    repeat(10000) begin

        // Get data from mailboxes
        mbx_1.get(cl_1);
        mbx_2.get(cl_2);
        mbx_3.get(cl_3);
        mbx_4.get(cl_4);
        mbx_5.get(cl_5);
        mbx_6.get(cl_6);

        // Check data

        // 1

        if( ! (cl_1.b > 0) ) begin
            $error("my_class_1.b <= 0");
            $display("my_class_1.b = %0d", cl_1.b);
        end
        
        if( ! (cl_1.a % cl_1.b == 0) ) begin
            $error("my_class_1.a is not divisible by my_class_1.b");
            $display("my_class_1.a = %0d", cl_1.a);
            $display("my_class_1.b = %0d", cl_1.b);
        end

        if( ! (cl_1.a > cl_1.b) ) begin
            $error("my_class_1.a <= my_class_1.b");
            $display("my_class_1.a = %0d", cl_1.a);
            $display("my_class_1.b = %0d", cl_1.b);
        end

        if( ! (cl_1.a + cl_1.b > 100) ) begin
            $error("my_class_1.a + my_class_1.b <= 100");
            $display("my_class_1.a = %0d", cl_1.a);
            $display("my_class_1.b = %0d", cl_1.b);
        end

        // 2

        if( cl_2.a == 0 && (cl_2.b != 100)) begin
            $error("my_class_2.a == 0, but my_class_2.b != 100");
            $display("my_class_2.a = %0d", cl_2.a);
            $display("my_class_2.b = %0d", cl_2.b);
        end

        if( ! (cl_2.a < 100) ) begin
            $error("my_class_2.a >= 100");
            $display("my_class_2.a = %0d", cl_2.a);
        end

        if( ! (cl_2.b > 50) ) begin
            $error("my_class_2.b <= 50");
            $display("my_class_2.b = %0d", cl_2.b);
        end

        // 3

        if( ! (cl_3.data.size() % 2 == 0) ) begin
            $error("my_class_3.data.size() is not even");
            $display("my_class_3.data = %p", cl_3.data);
        end

        if( ! (cl_3.data.size() < 10) ) begin
            $error("my_class_3.data.size() >= 10");
            $display("my_class_3.data = %p", cl_3.data);
        end

        foreach(cl_3.data[i]) begin
            if( ! (cl_3.data[i] < 200) ) begin
                $error("my_class_3.data[%0d] >= 200", i);
                $display("my_class_3.data[%0d] = %0d", i, cl_3.data[i]);
            end
            if( (i % 2 == 0) && ( cl_3.data[i] % 2 !=0 )) begin
                $error("my_class_3.data[%0d] is not even, but %0d is even", i, i);
                $display("my_class_3.data[%0d] = %0d", i, cl_3.data[i]);
            end
        end

        // 4

        if ( !(cl_4.data.size() == cl_4.size) ) begin
            $error("size of my_class_4.data != size field");
            $display("my_class_4.data = %p, my_class_4.size = %0d", cl_4.data, cl_4.size);
        end

        if ( cl_4.size == 3) begin
            foreach(cl_4.data[i]) begin
                if( cl_4.data[i] != 0 ) begin
                    $error("my_class_4.data[i] != 0, my_class_4.but size is 3");
                    $display("my_class_4.data[%0d] = %0d", i, cl_4.data[i]);
                end
            end
        end
        else begin
            foreach(cl_4.data[i]) begin
                if(cl_4.data[i] inside {data_queue}) begin
                    $error("my_class_4.size != 3, but my_class_4.data[%0d] is not unique", i);
                    $display("my_class_4.data = %p", cl_4.data);
                end
                data_queue.push_back(cl_4.data[i]);
            end
        end
        data_queue.delete();

        // 5
        if( ! (cl_5.addr[1:0] == 2'b00) ) begin
            $error("my_class_5.addr is not aligned");
            $display("my_class_5.addr = %b", cl_5.addr);
        end

        if( cl_5.req && !(cl_5.data inside {[100:200]})) begin
            $error("my_class_5.req is 1 but my_class_5.data not inside [100:200]");
            $display("my_class_5.data = %0d", cl_5.data);
        end

        if( cl_5.req && cl_5.we && cl_5.addr >= 128 ) begin
            $error("my_class_5.req and my_class_5.we are 1 but my_class_5.addr >= 128");
            $display("my_class_5.addr = %0d", cl_5.addr);
        end

        // 6

        if( ! (cl_6.tdata.size() == cl_6.tlast.size()) ) begin
            $error("my_class_6.tdata and my_class_6.tlast sizes are not equal");
            $display("my_class_6.tdata.size() = %0d, my_class_4.tlast.size() = %0d",
                cl_6.tdata.size(), cl_6.tlast.size());
        end
        if( !(cl_6.tdata.size() < 33) ) begin
            $error("my_class_6.tdata size is not < 33");
            $display("my_class_6.tdata.size() = %0d", cl_6.tdata.size());
        end
        if( ! (cl_6.tlast.size() < 33) ) begin
            $error("my_class_6.tlast size is not < 33");
            $display("my_class_6.tlast.size() = %0d", cl_6.tlast.size());
        end
        if( ! (cl_6.tdata.size() % 8 == 0) ) begin
            $error("my_class_6.tdata size is not divisible by 8");
            $display("my_class_6.tdata.size() = %0d", cl_6.tdata.size());
        end
        if( ! (cl_6.tlast.size() % 8 == 0) ) begin
            $error("my_class_6.tlast size is not divisible by 8");
            $display("my_class_6.tlast.size() = %0d", cl_6.tlast.size());
        end
        for(int i = 0; i < cl_6.tlast.size(); i = i + 1) begin
            if(cl_6.tlast[i]) begin
                for(int j = 1; j < 4; j = j + 1) begin
                    if(i + j > cl_6.tlast.size()) break;
                    if(cl_6.tlast[i + j]) begin
                        $error("my_class_6.tlast is 1 but only %0d tlasts were 0 before last 1", (i + j - 1) - i);
                        $display("my_class_6.tlast = %p", cl_6.tlast);
                    end
                end
                // Increment i by 3 because we checked next 3 tlast already
                i = i + 3;
            end
        end
    end
        
    $display("Test was finished! You are good if no errors.");
    $finish();
        
end
