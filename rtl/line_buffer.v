`timescale 1ns/1ps

module line_buffer(
    input wire clk,
    input wire rst,
    input wire [7:0] pixel_in,
    input wire pixel_in_valid,

    output reg [7:0] P1,P2,P3,
    output reg [7:0] P4,P5,P6,
    output reg [7:0] P7,P8,P9,
    output reg window_valid
);

reg [7:0] LB0 [0:127];
reg [7:0] LB1 [0:127];
reg [7:0] LB2 [0:127];

reg [6:0] col_counter;
reg [6:0] row_counter;
reg [1:0] write_ptr;

always @(posedge clk) begin
    if (rst) begin
        col_counter <= 0;
        row_counter <= 0;
        write_ptr   <= 0;
        window_valid <= 0;
    end
    else if (pixel_in_valid) begin

        // WRITE PIXEL
        case(write_ptr)
            0: LB0[col_counter] <= pixel_in;
            1: LB1[col_counter] <= pixel_in;
            2: LB2[col_counter] <= pixel_in;
        endcase

        // GENERATE WINDOW
        if (row_counter >= 2 && col_counter >= 2) begin
            case(write_ptr)
                0: begin
                    P1 <= LB1[col_counter-2];
                    P2 <= LB1[col_counter-1];
                    P3 <= LB1[col_counter];
                    P4 <= LB2[col_counter-2];
                    P5 <= LB2[col_counter-1];
                    P6 <= LB2[col_counter];
                    P7 <= LB0[col_counter-2];
                    P8 <= LB0[col_counter-1];
                    P9 <= LB0[col_counter];
                end

                1: begin
                    P1 <= LB2[col_counter-2];
                    P2 <= LB2[col_counter-1];
                    P3 <= LB2[col_counter];
                    P4 <= LB0[col_counter-2];
                    P5 <= LB0[col_counter-1];
                    P6 <= LB0[col_counter];
                    P7 <= LB1[col_counter-2];
                    P8 <= LB1[col_counter-1];
                    P9 <= LB1[col_counter];
                end

                2: begin
                    P1 <= LB0[col_counter-2];
                    P2 <= LB0[col_counter-1];
                    P3 <= LB0[col_counter];
                    P4 <= LB1[col_counter-2];
                    P5 <= LB1[col_counter-1];
                    P6 <= LB1[col_counter];
                    P7 <= LB2[col_counter-2];
                    P8 <= LB2[col_counter-1];
                    P9 <= LB2[col_counter];
                end
            endcase

            window_valid <= 1'b1;
        end
        else begin
            window_valid <= 1'b0;
        end

        // COUNTERS
        if (col_counter == 127) begin
            col_counter <= 0;
            row_counter <= row_counter + 1;

            if (write_ptr == 2)
                write_ptr <= 0;
            else
                write_ptr <= write_ptr + 1;

        end
        else begin
            col_counter <= col_counter + 1;
        end

    end
end

endmodule
