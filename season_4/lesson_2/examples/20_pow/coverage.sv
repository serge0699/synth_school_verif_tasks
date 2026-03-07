covergroup test_cfg_base_cg
    with function sample(test_cfg_base cfg);

    master_pkt_amount_cp:   coverpoint cfg.master_pkt_amount;
    master_size_min_cp:     coverpoint cfg.master_size_min;
    master_size_max_cp:     coverpoint cfg.master_size_max;
    master_delay_min_cp:    coverpoint cfg.master_delay_min;
    master_delay_max_cp:    coverpoint cfg.master_delay_max;
    slave_delay_min_cp:     coverpoint cfg.slave_delay_min;
    slave_delay_max_cp:     coverpoint cfg.slave_delay_max;
    test_timeout_cycles_cp: coverpoint cfg.test_timeout_cycles;

endgroup