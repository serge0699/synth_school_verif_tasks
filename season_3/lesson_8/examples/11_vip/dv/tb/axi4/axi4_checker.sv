class axi4_checker_base;

    // From monitor

    mailbox#(axi4_packet_base) mbx;

    // Transactions

    axi4_packet_base q_aw    [$];
    axi4_packet_base q_w     [$];
    axi4_packet_base q_b     [$];
    axi4_packet_base q_ar [8][$];
    axi4_packet_base q_r     [$];

    // Reset status

    bit in_reset;

    // Main run

    virtual task run();
        axi4_packet_base tmp_p;
        forever begin
            wait(~in_reset);
            fork
                do_check();
                wait(in_reset);
            join_any
            disable fork;
            while(mbx.try_get(tmp_p)) ;
        end
    endtask

    virtual task do_check();
        axi4_packet_base p;
        fork
            forever begin
                mbx.get(p);
                proc_p(p);
            end
            forever do_b();
            forever do_r();
        join
    endtask

    virtual function void proc_p(axi4_packet_base p);
        case(p.channel)
            AW: q_aw        .push_back(p);
            W : q_w         .push_back(p);
            B : q_b         .push_back(p);
            AR: q_ar[p.arid].push_back(p);
            R : q_r         .push_back(p);
        endcase
    endfunction

    virtual task do_b();
        axi4_packet_base p, p_aw, p_w;
        wait( q_b.size() );
        p = q_b.pop_front();
        if( !(q_aw.size() && q_w.size()) ) begin
            $error("%t Unexpected write response!", $time());
            // $stop();
        end
        else begin
            // Check if error
            if( p.bresp !== OKAY ) begin
                $error("%t Slave didn't return OKAY in write response!", $time());
                // $stop();
            end
            // Remove transactions from write queues
            p_aw = q_aw.pop_front();
            p_w  = q_w.pop_front();
            // Form final transaction and analyze
            p_aw.wdata = p_w.wdata;
            analyze_b(p_aw);
        end
    endtask

    virtual function void analyze_b(axi4_packet_base p);
        // Empty function for override
    endfunction

    virtual task do_r();
        axi4_packet_base p, p_ar;
        wait( q_r.size() );
        p = q_r.pop_front();
        if( !(q_ar[p.rid].size()) ) begin
            $error("%t Unexpected read response with %3b ID!",
                $time(), p.rid);
                // $stop();
        end
        else begin
            // Check if error
            if( p.rresp !== OKAY ) begin
                $error("%t Slave didn't return OKAY in read response!", $time());
                // $stop();
            end
            // Remove transaction from read queue
            p_ar = q_ar[p.rid].pop_front();
            // Form final transaction and analyze
            p_ar.rdata = p.rdata;
            analyze_r(p_ar);
        end
    endtask

    virtual function void analyze_r(axi4_packet_base p);
        // Empty function for override
    endfunction

endclass