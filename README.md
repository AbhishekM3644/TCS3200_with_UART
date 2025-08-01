# **Color Detection using TCS3200 and UART**

## **Overview**
This project implements a Verilog-based system to detect the color of an object using the **TCS3200** color sensor and transmit the detected color data via **UART communication**. The design integrates a **Bluetooth module** for wireless communication, with the entire system validated through simulation in **Vivado**.

The project is divided into tasks focusing on TCS3200 sensor interfacing and UART transmitter/receiver design.

---

## **Objectives**

- Design and implement a Verilog-based system to detect the color of an object using the TCS3200 sensor.
- Validate the design through high-level simulation in Vivado.

---

## **Project Structure**

- `tcs_3200.v`: Verilog module for TCS3200 color sensor interfacing.
- `uart_tx.v`: Verilog module for UART transmitter.
- `uart_rx.v`: Verilog module for UART receiver.
- `tb2`: Testbench for UART transmitter.
- `tb3`: Testbench for UART receiver.
- `tb1`: Testbench for the color detection system.
- `top_module`: Verilog module for integration of TCS3200 and UART
- `topmodule_tb`: Testbench for integration of TCS3200 and UART
- `results.txt`: Output file for testbench results.

---

## **Tasks Overview**

### **Task 1: TCS3200 Color Sensor Interfacing**

- **Description**: Interface the TCS3200 color sensor using Verilog.
- **Implementation**:  
  - Configure the **S2** and **S3** control signals to cycle through **Red**, **Green**, and **Blue** filters.
  - Measure the frequency of the sensor's PWM output (**OUT** pin) for each filter and detect the corresponding color.
- **Module**: `t1b_cd_fd`  
  - **Inputs**: `clk_1MHz`, `cs_out`  
  - **Outputs**: `filter[1:0]`, `color[1:0]`
- **Testbench**: `soc_color_detection_tb.v`
- **Deliverable**: Top-level Verilog module (`t1b_cd_fd`) with the specified I/O format.

---

### **Task 2: UART Communication Design**

- **Description**: Design and implement UART transmitter and receiver in Verilog.
- **Implementation**:
  - Transmit the detected color data via UART.
  - Receive data (if needed for acknowledgment or control).
- **Modules**:
  - `uart_tx`:  
    - **Inputs**: `clk_3125`, `parity_type`, `tx_start`, `data[7:0]`  
    - **Outputs**: `tx`, `tx_done`
  - `uart_rx`:  
    - **Inputs**: `clk_3125`, `rx`  
    - **Outputs**: `rx_msg[7:0]`, `rx_parity`, `rx_complete`
- **Testbenches**: `tb2.v`, `tb3.v`
- **Deliverables**: Top-level Verilog modules (`uart_tx`, `uart_rx`) with the specified I/O formats.

---

## **Main Task: System Integration and Simulation**

- **Description**: Integrate the TCS3200 color detection module with the UART transmitter and receiver.
- **Implementation**:
  - Design a comprehensive testbench to simulate continuous color detection and UART data transmission.
  - Validate the integrated system using **Vivado simulation**.
- **Testbench**: Combine functionality from `tb1.v`, `tb2.v`, and `tb3.v` for full system validation.


---

## **Usage**

- Modify `tcs_3200.v` to adjust filter cycling or color detection logic if needed.
- Adjust `uart_tx.v` and `uart_rx.v` for different baud rates (currently ~230,400 bps with 14 cycles/bit at 3.125 MHz).
- Run testbenches to validate each module and the integrated system.

---

## **Deliverables**

- Verilog modules: `tcs_3200`, `uart_tx`, `uart_rx`, `top_module.v`
- Testbenches: `tb1.v`, `tb2.v`, `tb3.v`,`topmodule_tb`
- Simulation results in `results.txt`

---

## **Notes**

- The baud rate is approximately **230,400 bps**, calculated from a 3.125 MHz clock with 14 cycles per bit.
- Ensure `clk_1MHz` and `clk_3125` are properly synchronized for integration.
