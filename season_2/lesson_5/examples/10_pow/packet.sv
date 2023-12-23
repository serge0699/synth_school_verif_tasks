    class packet;
        rand int          delay;
        rand logic [31:0] tdata;
        rand logic        tid;
        rand logic        tlast;
    endclass

    class small_data_packet extends packet;
        constraint tdata_c {tdata inside {[0:256]};}
    endclass