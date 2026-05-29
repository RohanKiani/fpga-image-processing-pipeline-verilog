# FPGA-Based Real-Time Image Processing Pipeline Using Verilog HDL

## Overview

This project implements a real-time image processing pipeline on FPGA using Verilog HDL. The system performs spatial convolution on grayscale image data and displays the processed output on a VGA monitor.

The architecture is fully streaming-based and optimized for FPGA resources using line buffers, BRAM storage, and pipelined convolution logic.

The design demonstrates core FPGA and RTL engineering concepts including:
- Streaming datapath architecture
- Hardware convolution engine
- Line-buffer based sliding window generation
- BRAM-based frame buffering
- VGA synchronization and display system
- FSM-based control flow design

---

## System Architecture

The system is composed of modular RTL blocks forming a streaming pipeline:

- Image Memory (BROM / IP Core)
- Line Buffer Module (3-line sliding window generator)
- Convolution Engine (3×3 spatial filter)
- Frame Buffer (BRAM IP Core)
- VGA Synchronization Controller
- Top-Level FSM Controller

The architecture follows a pixel-streaming model where data flows continuously through processing stages without full-frame buffering.

---

## Design Flow

1. Image is preloaded into Block ROM (BROM IP Core)
2. Pixel stream is fed into line buffer architecture
3. A 3×3 sliding window is generated per clock cycle
4. Convolution engine applies spatial filtering kernel
5. Processed pixels are stored into BRAM frame buffer
6. After processing completion, VGA controller reads BRAM
7. Output image is displayed on 640×480 VGA monitor

---

## RTL Modules

- `top_module.v` → System integration + control FSM
- `vga_sync.v` → VGA timing generator (HSYNC / VSYNC)
- `line_buffer.v` → 3×3 sliding window generator
- `conv_engine.v` → Convolution processing unit
- `BRAM.v` → FPGA BRAM IP interface
- `BROM.v` → Image ROM interface

---

## Convolution Engine

The convolution engine performs 3×3 spatial filtering using a uniform averaging kernel:

### Kernel:
1 1 1
1 1 1
1 1 1

### Operation:
- Multiply each pixel in the window with kernel coefficients
- Accumulate results using combinational logic
- Normalize output using bit shifting
- Clamp result to 8-bit range (0–255)

This produces a smoothing / blur effect on the input image.

---

## VGA Display System

The VGA subsystem operates at standard 640×480 @ 60Hz timing using a 25 MHz pixel clock.

Features:
- Horizontal and vertical synchronization generation
- Active video region detection
- RGB332 color encoding
- BRAM-based pixel fetch during display phase

---

## Streaming Pipeline Architecture

The system implements a fully streaming datapath:

BROM → Line Buffer → Convolution Engine → BRAM → VGA Output

Each stage processes pixel data sequentially, enabling continuous real-time processing after pipeline fill.

No full-frame buffering is used, significantly reducing FPGA BRAM usage.

---

## Verification

The design was verified using Verilog testbenches and waveform analysis.

Validation includes:
- Sliding window correctness
- Convolution output verification
- BRAM read/write integrity
- VGA timing validation
- FSM state transition correctness

---

## FPGA Design Considerations

- Limited BRAM resources required streaming architecture
- Line buffering eliminates full-frame storage requirement
- Fully synchronous design ensures timing stability
- FSM controls processing and display phases
- Pipelined computation improves throughput efficiency

---

## Output Results

- Real-time grayscale image filtering implemented successfully
- Convolution-based smoothing verified in simulation
- VGA output displayed correctly on hardware
- End-to-end pipeline validated through testbench and FPGA deployment

---

## Future Improvements

- Sobel edge detection filter
- Gaussian blur implementation
- Median filtering module
- AXI-stream interface integration
- Higher resolution support (720p / 1080p)
- Pipeline optimization for higher throughput

---

## Tools & Technologies

- Verilog HDL
- FPGA (Nexys2 / Xilinx FPGA boards)
- Xilinx Vivado
- ModelSim Simulation
- Block RAM (BRAM IP Core)
- VGA Display Interface
