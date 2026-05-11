`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2026 10:33:19 PM
// Design Name: 
// Module Name: axi_bcd_filter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module axi_bcd_filter #(
    parameter bit bsd_check = 1
    )(
    input logic         clk,
    input logic         rst,
    
    input logic         s_axis_tvalid,
    input logic  [7:0]  s_axis_tdata,
    output logic        s_axis_tready,
    
    output logic        m_axis_tvalid,
    output logic [7:0]  m_axis_tdata,
    input logic         m_axis_tready
    );
    
    logic [3:0] tens;
    logic [3:0] ones;
    
    logic pass_filter;
    
    logic s_handshake;
    logic m_handshake;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            m_axis_tvalid <= 0;
            m_axis_tdata <= 0;    
        end else begin
            if (m_handshake) begin
                m_axis_tvalid<=0;
            end
            if (s_handshake) begin
                if (pass_filter) begin
                    m_axis_tdata<=s_axis_tdata;
                    m_axis_tvalid<=1; 
                end 
            end
            
        end   
    end
    
    assign tens = s_axis_tdata[7:4];
    assign ones = s_axis_tdata[3:0];
    assign pass_filter = ((!bsd_check) || ((tens < 4'b1010) && (ones <  4'b1010))) && (((tens * 4'b1010 + ones) % 4) == 0);
    assign s_handshake = s_axis_tvalid && s_axis_tready;
    assign m_handshake = m_axis_tvalid && m_axis_tready;
    assign s_axis_tready = m_axis_tready || !m_axis_tvalid;
    
endmodule
