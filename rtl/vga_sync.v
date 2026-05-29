`timescale 1ns/1ps

module vga_sync(
    input wire clock_25MHz,
    input wire [2:0] red,
    input wire [2:0] green,
    input wire [1:0] blue,
    output reg [2:0] red_out,
    output reg [2:0] green_out,
    output reg [1:0] blue_out,
    output reg hsync,
    output reg vsync,
    output reg [9:0] pixel_row,
    output reg [9:0] pixel_col
);

reg [9:0] h_cnt = 0;
reg [9:0] v_cnt = 0;
reg video_on;

always @(posedge clock_25MHz) begin

    // HORIZONTAL COUNTER
    if (h_cnt == 799)
        h_cnt <= 0;
    else
        h_cnt <= h_cnt + 1;

    // VERTICAL COUNTER
    if (h_cnt == 799) begin
        if (v_cnt == 524)
            v_cnt <= 0;
        else
            v_cnt <= v_cnt + 1;
    end

    // HSYNC
    hsync <= ~((h_cnt >= 656) && (h_cnt < 752));

    // VSYNC
    vsync <= ~((v_cnt >= 490) && (v_cnt < 492));

    // VIDEO ENABLE
    video_on <= (h_cnt < 640) && (v_cnt < 480);

    // CURRENT PIXEL LOCATION
    pixel_col <= h_cnt;
    pixel_row <= v_cnt;

    // RGB OUTPUTS
    if(video_on) begin
        red_out   <= red;
        green_out <= green;
        blue_out  <= blue;
    end
    else begin
        red_out   <= 0;
        green_out <= 0;
        blue_out  <= 0;
    end

end

endmodule
