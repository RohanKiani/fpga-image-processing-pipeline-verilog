`timescale 1ns/1ps

module top_module(
    input  wire clk,
    output wire [2:0] red_out,
    output wire [2:0] green_out,
    output wire [1:0] blue_out,
    output wire hsync,
    output wire vsync
);

// CLOCK DIVIDE
reg clk_25mhz = 0;
always @(posedge clk)
    clk_25mhz <= ~clk_25mhz;

// INPUT ADDRESS COUNTER
reg [13:0] pixel_addr;
reg pixel_in_valid;

initial begin
    pixel_addr = 0;
    pixel_in_valid = 0;
end

always @(posedge clk) begin
    if (pixel_addr < 16384) begin
        pixel_addr <= pixel_addr + 1;
        pixel_in_valid <= 1;
    end
    else
        pixel_in_valid <= 0;
end

// BROM
wire [7:0] pixel_data;

BROM brom0(
    .clka(clk),
    .addra(pixel_addr),
    .douta(pixel_data)
);

reg pixel_in_valid_d;

always @(posedge clk)
    pixel_in_valid_d <= pixel_in_valid;

// LINE BUFFER
wire [7:0] P1,P2,P3,P4,P5,P6,P7,P8,P9;
wire window_valid;

// CONV ENGINE
wire [7:0] pixel_out;
wire pixel_out_valid;
wire done;
wire [13:0] ce_bram_addr;

conv_engine CE (
    .clk(clk),
    .window_valid(window_valid),
    .P1(P1), .P2(P2), .P3(P3),
    .P4(P4), .P5(P5), .P6(P6),
    .P7(P7), .P8(P8), .P9(P9),
    .pixel_out(pixel_out),
    .pixel_out_valid(pixel_out_valid),
    .done(done),
    .bram_addr_out(ce_bram_addr)
);

// VGA ADDRESS GENERATION
wire [9:0] pixel_row;
wire [9:0] pixel_col;

reg [13:0] vga_addr;

always @(*) begin
    if (pixel_row < 128 && pixel_col < 128)
        vga_addr = pixel_col * 128 + pixel_row;
    else
        vga_addr = 0;
end

// BRAM ADDRESS PIPELINE
reg [13:0] vga_addr_d;

always @(posedge clk_25mhz)
    vga_addr_d <= vga_addr;

// BRAM CONTROL
wire [13:0] bram_addr;

assign bram_addr = (!done) ? ce_bram_addr : vga_addr_d;

wire bram_we = pixel_out_valid && !done;

// BRAM
wire [7:0] bram_dout;

BRAM bram_inst(
    .clka(clk),
    .wea(bram_we),
    .addra(bram_addr),
    .dina(pixel_out),
    .douta(bram_dout)
);

// RGB332 OUTPUT
wire [2:0] red;
wire [2:0] green;
wire [1:0] blue;

assign red   = done ? bram_dout[7:5] : 0;
assign green = done ? bram_dout[7:5] : 0;
assign blue  = done ? bram_dout[7:6] : 0;

// VGA MODULE
vga_sync VGA(
    .clock_25MHz(clk_25mhz),
    .red(red),
    .green(green),
    .blue(blue),
    .red_out(red_out),
    .green_out(green_out),
    .blue_out(blue_out),
    .hsync(hsync),
    .vsync(vsync),
    .pixel_row(pixel_row),
    .pixel_col(pixel_col)
);

endmodule
