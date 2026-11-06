module pow (

    input logic        clk,
    input logic        aresetn,

    // AXI-Stream на вход
    input  logic        s_tvalid,
    output logic        s_tready,
    input  logic [31:0] s_tdata,
    input  logic        s_tid,
    input  logic        s_tlast,

    // AXI-Stream на выход
    output logic        m_tvalid,
    input  logic        m_tready,
    output logic [31:0] m_tdata,
    output logic        m_tid,
    output logic        m_tlast

);

    logic        tvalid_ff     [5];
    logic [31:0] tdata_ff      [5];
    logic [31:0] tdata_tmp_ff  [5];
    logic        tid_ff        [5];
    logic        tlast_ff      [5];

    always_ff @(posedge clk or negedge aresetn) begin
        if( ~aresetn ) begin
            for(int i = 0; i < 5; i++) begin
                tvalid_ff    [i] <= 'b0;
                tdata_ff     [i] <= 'b0;
                tdata_tmp_ff [i] <= 'b0;
                tid_ff       [i] <= 'b0;
                tlast_ff     [i] <= 'b0;
            end
        end
        else if ( s_tready ) begin
            tvalid_ff    [0] <= s_tvalid;
            tdata_ff     [0] <= s_tdata;
            tdata_tmp_ff [0] <= s_tdata;
            tid_ff       [0] <= s_tid;
            tlast_ff     [0] <= s_tlast;
            for(int i = 1; i < 4; i++) begin
                tdata_tmp_ff [i] <= tdata_tmp_ff[i-1];
            end
            for(int i = 1; i < 5; i++) begin
                tvalid_ff    [i] <= tvalid_ff [i-1];
                tdata_ff     [i] <= tdata_ff  [i-1] * tdata_tmp_ff  [i-1];
                tid_ff       [i] <= tid_ff    [i-1];
                tlast_ff     [i] <= tlast_ff  [i-1];
            end
        end
    end

    assign s_tready = tvalid_ff [4] & ~m_tready ? 0 : 1;
    assign m_tvalid = tvalid_ff [4];
    assign m_tdata  = tdata_ff  [4];
    assign m_tid    = tid_ff    [4];
    assign m_tlast  = tlast_ff  [4];

endmodule
