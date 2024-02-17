    // APB master
    
    class array_alu_apb_work_mode_resp_driver extends apb_master_driver_base;

        virtual task drive_master(apb_packet_base p);
            super.drive_master(p);
            // If we read done register - put response
            if( p.paddr == DONE ) begin
                p.prdata = vif.prdata;
                gen2drv.put(p);
            end
        endtask

    endclass
