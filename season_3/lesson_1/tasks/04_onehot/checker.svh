    event gen_done;

    covergroup onehot_cg(string name) @(bin);
        in_cp: coverpoint bin;
        option.name = name;
    endgroup

    onehot_cg cg_bin = new("bin");

    function automatic void display_summary();
        $display("Summary:");
        $display($sformatf("Binary: %3.3f%%", cg_bin.get_inst_coverage()));
    endfunction

    initial begin
        wait(gen_done.triggered());
        display_summary();
        $stop();
    end