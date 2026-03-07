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

module mult (

    input logic         clk,
    input logic         aresetn,

    input  logic        s_tvalid,
    output logic        s_tready,
    input  logic [31:0] s_tdata,
    input  logic        s_tid,
    input  logic        s_tlast,

    output logic        m_tvalid,
    input  logic        m_tready,
    output logic [31:0] m_tdata,
    output logic        m_tid,
    output logic        m_tlast

);

    logic        tvalid_ff;
    logic [31:0] tdata_ff;
    logic        tid_ff;
    logic        tlast_ff;

    always_ff @(posedge clk or negedge aresetn) begin
        if( ~aresetn ) begin
            tvalid_ff    <= 'b0;
            tdata_ff     <= 'b0;
            tid_ff       <= 'b0;
            tlast_ff     <= 'b0;
        end
        else if ( s_tready ) begin
            tvalid_ff    <= s_tvalid;
            tdata_ff     <= s_tdata * s_tdata;
            tid_ff       <= s_tid;
            tlast_ff     <= s_tlast;
        end
    end

    assign s_tready = tvalid_ff & ~m_tready ? 0 : 1;
    assign m_tvalid = tvalid_ff;
    assign m_tdata  = tdata_ff;
    assign m_tid    = tid_ff;
    assign m_tlast  = tlast_ff;

endmodule

module complex (

    input logic        clk,
    input logic        aresetn,

    // AXI-Stream 1 на вход
    input  logic        s1_tvalid,
    output logic        s1_tready,
    input  logic [31:0] s1_tdata,
    input  logic        s1_tid,
    input  logic        s1_tlast,

    // AXI-Stream 1 на выход
    output logic        m1_tvalid,
    input  logic        m1_tready,
    output logic [31:0] m1_tdata,
    output logic        m1_tid,
    output logic        m1_tlast,

    // AXI-Stream 2 на вход
    input  logic        s2_tvalid,
    output logic        s2_tready,
    input  logic [31:0] s2_tdata,
    input  logic        s2_tid,
    input  logic        s2_tlast,

    // AXI-Stream 2 на выход
    output logic        m2_tvalid,
    input  logic        m2_tready,
    output logic [31:0] m2_tdata,
    output logic        m2_tid,
    output logic        m2_tlast

);

    pow pow_inst (
        .clk        ( clk       ),
        .aresetn    ( aresetn   ),
        .s_tvalid   ( s1_tvalid ),
        .s_tready   ( s1_tready ),
        .s_tdata    ( s1_tdata  ),
        .s_tid      ( s1_tid    ),
        .s_tlast    ( s1_tlast  ),
        .m_tvalid   ( m1_tvalid ),
        .m_tready   ( m1_tready ),
        .m_tdata    ( m1_tdata  ),
        .m_tid      ( m1_tid    ),
        .m_tlast    ( m1_tlast  )
    );

    mult mult_inst (
        .clk        ( clk       ),
        .aresetn    ( aresetn   ),
        .s_tvalid   ( s2_tvalid ),
        .s_tready   ( s2_tready ),
        .s_tdata    ( s2_tdata  ),
        .s_tid      ( s2_tid    ),
        .s_tlast    ( s2_tlast  ),
        .m_tvalid   ( m2_tvalid ),
        .m_tready   ( m2_tready ),
        .m_tdata    ( m2_tdata  ),
        .m_tid      ( m2_tid    ),
        .m_tlast    ( m2_tlast  )
    );

endmodule