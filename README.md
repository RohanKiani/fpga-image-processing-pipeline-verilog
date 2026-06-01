# FPGA-Based Real-Time Image Processing Pipeline Using Verilog HDL

## Overview

This project implements a real-time FPGA-based image processing pipeline in Verilog HDL. The system performs 3×3 spatial convolution on grayscale image data and displays the processed output through a VGA interface.

The design follows a streaming hardware architecture that leverages FPGA on-chip memory resources, line buffering, and pipelined processing to achieve efficient pixel-level computation.

The project demonstrates several key FPGA and RTL design concepts:

- Streaming datapath architecture
- Hardware-accelerated image filtering
- Sliding-window generation using line buffers
- FPGA memory hierarchy using BRAM and BROM IP cores
- VGA timing generation and display control
- Synchronous RTL design and control logic

---

## System Architecture

The image processing system is organized as a modular streaming pipeline:

- Image Memory (BROM IP Core)
- Line Buffer Module
- 3×3 Convolution Engine
- Frame Buffer (BRAM IP Core)
- VGA Synchronization Controller
- Top-Level Control Logic

The architecture processes pixels sequentially as they flow through the pipeline, minimizing memory usage while maintaining continuous throughput.

---

## Design Flow

1. Input image is preloaded into Block ROM (BROM).
2. Pixels are streamed sequentially into the line buffer subsystem.
3. The line buffer generates valid 3×3 sliding windows.
4. The convolution engine applies spatial filtering to each window.
5. Processed pixels are written into Block RAM (BRAM).
6. Upon completion of processing, the VGA subsystem reads the processed image from BRAM.
7. The filtered image is displayed on a VGA monitor.

---

## FPGA Memory Architecture

### Block ROM (BROM)

The input grayscale image is stored inside a Xilinx Block ROM (BROM) IP core.

Features:

- Read-only image storage
- Deterministic memory access
- Pre-initialized image data
- Eliminates external image transfer requirements

### Block RAM (BRAM)

The processed output image is stored in a Xilinx Block RAM (BRAM) IP core.

Features:

- On-chip frame buffer storage
- Synchronous read/write operation
- Shared between processing and display stages
- Efficient utilization of FPGA memory resources

### Memory Flow

```text
BROM (Input Image)
        ↓
Line Buffer
        ↓
Convolution Engine
        ↓
BRAM (Frame Buffer)
        ↓
VGA Controller
        ↓
Display Output
```

---

## RTL Modules

### `top_module.v`

Top-level integration module responsible for:

- Clock division
- Memory interfacing
- Module integration
- BRAM control
- VGA display control
- System-level data flow

### `line_buffer.v`

Generates valid 3×3 sliding windows using three line buffers.

Features:

- Continuous pixel streaming
- Window-valid generation
- Reduced memory requirements
- Hardware-efficient neighborhood extraction

### `conv_engine.v`

Implements a 3×3 convolution filter.

Responsibilities:

- Window processing
- Multiply-accumulate operations
- Output normalization
- Frame-buffer addressing
- Processing completion signaling

### `vga_sync.v`

Generates VGA timing signals.

Features:

- HSYNC generation
- VSYNC generation
- Pixel coordinate generation
- Active display region control
- RGB output synchronization

### `BROM.v`

Xilinx Block ROM IP interface used for image storage.

### `BRAM.v`

Xilinx Block RAM IP interface used as the processed image frame buffer.

---

## Convolution Engine

The convolution engine performs spatial filtering using a 3×3 averaging kernel.

### Kernel

```text
1 1 1
1 1 1
1 1 1
```

### Processing Steps

- Generate a valid 3×3 pixel neighborhood
- Multiply pixels by kernel coefficients
- Accumulate partial sums
- Normalize result through bit shifting
- Clamp output to the 8-bit range

The resulting filter performs image smoothing and noise reduction.

---

## VGA Display System

The VGA subsystem operates using standard 640×480 @ 60 Hz timing with a 25 MHz pixel clock.

Capabilities:

- Horizontal synchronization generation
- Vertical synchronization generation
- Active video region detection
- RGB332 output formatting
- BRAM-based image rendering

---

## Streaming Pipeline Architecture

The complete processing pipeline is:

```text
BROM → Line Buffer → Convolution Engine → BRAM → VGA Output
```

Key characteristics:

- Fully streaming architecture
- Continuous pixel processing
- Minimal memory overhead
- FPGA-friendly implementation
- Real-time display capability

Unlike conventional software implementations, the design processes image data directly in hardware using dedicated RTL modules.

---

## Verification

Functional verification was performed using Verilog simulation and waveform analysis.

Verified functionality includes:

- Sliding-window generation
- Convolution correctness
- BRAM read/write operations
- VGA timing behavior
- Address generation logic
- End-to-end image processing flow

---

## Results

The design successfully demonstrated:

- Real-time grayscale image processing
- Correct 3×3 convolution filtering
- Reliable BRAM frame buffering
- VGA image display functionality
- Complete RTL-level system integration

Simulation and hardware testing confirmed correct operation of the image processing pipeline.

---

## FPGA Design Considerations

Several architectural decisions were made to optimize FPGA resource utilization:

- Streaming architecture instead of full-frame buffering
- Line-buffer-based window generation
- On-chip memory utilization through BRAM/BROM IP cores
- Fully synchronous RTL implementation
- Modular and scalable design structure

These choices improve resource efficiency while maintaining deterministic hardware behavior.

---

## Future Improvements

Potential extensions include:

- Sobel edge detection
- Gaussian filtering
- Sharpening filters
- Median filtering
- Color image processing
- AXI-Stream integration
- Higher-resolution image support
- Fully pipelined convolution architectures
- Real-time camera input

---

## Tools & Technologies

- Verilog HDL
- Xilinx ISE
- ModelSim
- FPGA Development Boards (Nexys2board)
- Block ROM (BROM IP Core)
- Block RAM (BRAM IP Core)
- VGA Display Interface

---

## Project Highlights

- FPGA-Based Image Processing
- RTL Design and Verification
- Streaming Hardware Architecture
- VGA Graphics Subsystem
- BRAM/BROM Integration
- Verilog HDL Development
- Digital System Design
- Computer Architecture Concepts
