    event gen_done;

    covergroup sum_cg (string name) with function sample(logic [31:0] data);
        data_cp: coverpoint data {
            bins intervals [8] = {[0:$]};
        }
        option.name = name;
        option.per_instance = 1;
    endgroup

    sum_cg cg_a = new("A");
    sum_cg cg_b = new("B");

    function automatic void display_summary();
        $display("Summary:");
        $display($sformatf("Operand A: %3.3f%%", cg_a.get_inst_coverage()));
        $display($sformatf("Operand B: %3.3f%%", cg_b.get_inst_coverage()));
    endfunction

    initial begin
        fork
            // Collect data from A and B every minimal step
            forever begin
                #1step;
                cg_a.sample(A);
                cg_b.sample(B);
            end
            // Wait for user data generation ending
            wait(gen_done.triggered());
        join_any
        // Process 2 minimal steps to obtain final data
        repeat(2) #1step;
        // Disable collecting and print summary
        disable fork;
        display_summary();
        $stop();
    end