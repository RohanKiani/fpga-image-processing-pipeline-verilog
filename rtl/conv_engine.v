`timescale 1ns/1ps

module conv_engine(
    input  wire        clk,
    input  wire        window_valid,
    input  wire [7:0]  P1,P2,P3,
    input  wire [7:0]  P4,P5,P6,
    input  wire [7:0]  P7,P8,P9,

    output reg  [7:0]  pixel_out,
    output reg         pixel_out_valid,
    output reg         done,
    output reg  [13:0] bram_addr_out
);

reg [7:0] kernel [0:8];

initial begin
    kernel[0]=1; kernel[1]=1; kernel[2]=1;
    kernel[3]=1; kernel[4]=1; kernel[5]=1;
    kernel[6]=1; kernel[7]=1; kernel[8]=1;
end

reg [6:0] out_row;
reg [6:0] out_col;
reg [19:0] sum;

initial begin
    out_row         = 7'd1;
    out_col         = 7'd1;

    done            = 1'b0;

    pixel_out       = 8'd0;
    pixel_out_valid = 1'b0;

    bram_addr_out   = 14'd129;
end

always @(posedge clk) begin

    pixel_out_valid <= 1'b0;

    if (window_valid && !done) begin

        // convolution sum
        sum <= (P1*kernel[0]) + (P2*kernel[1]) + (P3*kernel[2]) +
               (P4*kernel[3]) + (P5*kernel[4]) + (P6*kernel[5]) +
               (P7*kernel[6]) + (P8*kernel[7]) + (P9*kernel[8]);

        // divide by 8 and clamp
        if ((sum >> 3) > 255)
            pixel_out <= 8'd255;
        else
            pixel_out <= sum[10:3];

        // store address
        bram_addr_out <= (out_row * 14'd128) + out_col;

        pixel_out_valid <= 1'b1;

        // done condition
        if (out_row == 7'd126 && out_col == 7'd126)
            done <= 1'b1;

        // counter update
        else if (out_col == 7'd126) begin
            out_col <= 7'd1;
            out_row <= out_row + 7'd1;
        end
        else begin
            out_col <= out_col + 7'd1;
        end

    end
end

endmodule
