    event ev;
    
    initial begin
        for(int i = 0; i < 8; i++) begin
            {c, b, a} = i;
            #1; ->> ev;
            #9;
        end
        $stop();
    end