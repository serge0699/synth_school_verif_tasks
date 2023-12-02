    typedef logic [31:0] word_t;
    typedef word_t words_t [$];


    function automatic words_t get_b_127_255();
        words_t result;
        for(word_t i = 127; i < 255 + 1; i = i + 4)
            result.push_back(i);
        return result;
    endfunction

    function automatic words_t get_b_3ff_103fe();
        words_t result;
        word_t cnt = 1023;
        repeat(13108) begin
            result.push_back(cnt);
            cnt = cnt + 5;
        end
        return result;
    endfunction

    function automatic words_t get_b_ffffffff_ffffbfff();
        words_t result;
        word_t cnt = 32'hFFFFFFFF;
        repeat(513) begin
            result.push_back(cnt);
            cnt = cnt - 32;
        end
        return result;
    endfunction
    
    covergroup sum_cg with function sample(logic [31:0] a, logic [31:0] b);

        coverpoint a {
            bins b_0_100     [ 101]  = {[0:100]};
            bins b_127_255   [  32]  = get_b_127_255();
            bins b_3ff_103fe [13107] = get_b_3ff_103fe();
            illegal_bins illegal = default;
        }

        coverpoint b {
            bins b_100_0             [ 101] = {[0:100]};
            bins b_127_255           [  32] = get_b_127_255();
            bins b_ffffffff_ffffbffd [ 512] = get_b_ffffffff_ffffbfff();
            illegal_bins illegal = default;
        }

    endgroup

    event gen_done;
    sum_cg cg = new();

    initial begin
        wait(aresetn);
        fork
            forever begin
                @(posedge clk);
                #1step;
                cg.sample(A, B);
            end
            @(gen_done);
        join_any
        @(posedge clk);
        disable fork;
        $stop();
    end