**Bluetooth-Operated Color Detection System using TCS3200 and UART Communication**
**Overview**
This project implements a Verilog-based system to detect the color of an object using the TCS3200 color sensor and transmit the detected color data via UART communication. The design integrates a Bluetooth module for wireless communication, with the entire system validated through simulation in Vivado. The project is divided into tasks focusing on TCS3200 sensor interfacing and UART transmitter/receiver design.
**Objectives**

Design and implement a Verilog-based system to detect the color of an object using the TCS3200 sensor.
Simulate UART communication with a Bluetooth module.
Validate the design through high-level simulation in Vivado.

Project Structure

tcs_3200.v: Verilog module for TCS3200 color sensor interfacing (t1b_cd_fd).
uart_tx.v: Verilog module for UART transmitter.
uart_rx1.v: Verilog module for UART receiver.
uart_tx_tb.v: Testbench for UART transmitter.
uart_rx_text.v: Testbench for UART receiver.
soc_color_detection_tb.v: Testbench for the color detection system (uneditable reference).
results.txt: Output file for testbench results.

Tasks Overview
Task 1: TCS3200 Color Sensor Interfacing

Description: Interface the TCS3200 color sensor using Verilog.
Implementation:
Configure the S2 and S3 control signals to cycle through Red, Green, and Blue filters.
Measure the frequency of the sensor's PWM output (OUT pin) for each filter and detect the corresponding color.


Module: t1b_cd_fd
Inputs: clk_1MHz, cs_out
Outputs: filter[1:0], color[1:0]


Testbench: soc_color_detection_tb.v
Deliverable: Top-level Verilog module (t1b_cd_fd) with the specified I/O format.

Task 2: UART Communication Design

Description: Design and implement UART transmitter and receiver in Verilog.
Implementation:
Transmit the detected color data via UART.
Receive data (if needed for acknowledgment or control).


Modules:
uart_tx: Transmitter module
Inputs: clk_3125, parity_type, tx_start, data[7:0]
Outputs: tx, tx_done


uart_rx1: Receiver module
Inputs: clk_3125, rx
Outputs: rx_msg[7:0], rx_parity, rx_complete




Testbenches: uart_tx_tb.v, uart_rx_text.v
Deliverables: Top-level Verilog modules (uart_tx, uart_rx1) with the specified I/O formats.

Main Task: System Integration and Simulation

Description: Integrate the TCS3200 color detection module with the UART transmitter and receiver.
Implementation:
Design a comprehensive testbench to simulate continuous color detection and UART data transmission.
Validate the integrated system using Vivado simulation.


Testbench: Combine functionality from soc_color_detection_tb.v, uart_tx_tb.v, and uart_rx_text.v for full system validation.

Setup Instructions

Install Vivado: Ensure Xilinx Vivado is installed with Verilog support.
Clone the Repository: Download or clone this project directory.
Open Project in Vivado:
Create a new project in Vivado.
Add all .v files to the project sources.


Run Simulation:
Set soc_color_detection_tb.v as the top-level module for initial color detection testing.
Set uart_tx_tb.v and uart_rx_text.v for UART module testing.
Run behavioral simulation and check results.txt for errors.


Integrate and Validate:
Connect t1b_cd_fd output (color) to uart_tx input (data).
Simulate the integrated system and verify UART transmission.



Usage

Modify t1b_cd_fd.v to adjust filter cycling or color detection logic if needed.
Adjust uart_tx.v and uart_rx1.v for different baud rates (currently ~230,400 bps with 14 cycles/bit at 3.125 MHz).
Run testbenches to validate each module and the integrated system.

Deliverables

Verilog modules: t1b_cd_fd, uart_tx, uart_rx1.
Testbenches: soc_color_detection_tb.v, uart_tx_tb.v, uart_rx_text.v.
Simulation results in results.txt.

Notes

The baud rate is approximately 230,400 bps, calculated from a 3.125 MHz clock with 14 cycles per bit.
Ensure clk_1MHz and clk_3125 are properly synchronized for integration.
Refer to the problem statement image for detailed task requirements.

Contact
For questions or support, contact [Your Name/Email].
