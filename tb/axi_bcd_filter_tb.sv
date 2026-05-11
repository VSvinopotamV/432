`timescale 1ns / 1ps

module tb_axi_bcd_filter;
    logic       clk;
    logic       rst;
    logic       s_axis_tvalid;
    logic [7:0] s_axis_tdata;
    logic       s_axis_tready;
    logic       m_axis_tvalid;
    logic [7:0] m_axis_tdata;
    logic       m_axis_tready;
    logic [3:0] rand_tens;
    logic [3:0] rand_ones;

    axi_bcd_filter #(
        .bsd_check(1'b1)
    )dut(
        .clk(clk),
        .rst(rst),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tready(s_axis_tready),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tready(m_axis_tready)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        s_axis_tvalid = 1'b0;
        s_axis_tdata  = 8'h00;
        m_axis_tready = 1'b1;
        #45;
        rst = 1'b0;

        repeat (50) begin
            @(posedge clk);
            rand_tens = $urandom_range(0, 15);
            rand_ones = $urandom_range(0, 15);

            s_axis_tdata  <= {rand_tens, rand_ones};
            s_axis_tvalid <= 1'b1;

            wait (s_axis_tready == 1'b1);

            @(posedge clk);
            s_axis_tvalid <= 1'b0;
        end
        $finish;
    end

    initial begin
        forever begin
            repeat (3) begin
                @(posedge clk);
                m_axis_tready <= 1'b1;
            end
            repeat (2) begin
                @(posedge clk);
                m_axis_tready <= 1'b0;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (m_axis_tvalid) begin
            $display("pass = %h", m_axis_tdata);
        end
    end

endmodule