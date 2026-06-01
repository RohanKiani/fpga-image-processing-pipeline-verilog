`timescale 1ns/1ps

module tb_top;

// CLOCK SIGNAL

reg clk = 0;

always #10 clk = ~clk;  // 50 MHz clock

// OUTPUT SIGNALS FROM TOP
wire [2:0] red_out;
wire [2:0] green_out;
wire [1:0] blue_out;
wire hsync;
wire vsync;


// INSTANTIATE TOP MODULE

top_module DUT (
    .clk(clk),
    .red_out(red_out),
    .green_out(green_out),
    .blue_out(blue_out),
    .hsync(hsync),
    .vsync(vsync)
);

// SIMULATION CONTROL

initial begin

    // Monitor key signals
    $monitor("Time=%0t | RGB=%b%b%b | HSYNC=%b VSYNC=%b",
              $time, red_out, green_out, blue_out, hsync, vsync);

    // Run simulation for sufficient time
    #200000;

    $display("Simulation Completed");
    $finish;
end

endmodule
