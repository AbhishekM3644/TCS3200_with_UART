# **Bluetooth-Operated Color Detection System**

## **Overview**
This project implements a Verilog-based system to detect the color of an object using the **TCS3200** color sensor and transmit the detected color data via **UART communication**. The design integrates a **Bluetooth module** for wireless communication, with the entire system validated through simulation in **Vivado**.

The project is divided into tasks focusing on TCS3200 sensor interfacing and UART transmitter/receiver design.

---

## **Objectives**

- Design and implement a Verilog-based system to detect the color of an object using the TCS3200 sensor.
- Simulate UART communication with a Bluetooth module.
- Validate the design through high-level simulation in Vivado.

---

## **Project Structure**

- `tcs_3200.v`: Verilog module for TCS3200 color sensor interfacing (`t1b_cd_fd`).
- `uart_tx.v`: Verilog module for UART transmitter.
- `uart_rx1.v`: Verilog module for UART receiver.
- `uart_tx_tb.v`: Testbench for UART transmitter.
- `uart_rx_text.v`: Testbench for UART receiver.
- `soc_color_detection_tb.v`: Testbench for the color detection system (**uneditable reference**).
- `results.txt`: Output file for testbench results.

---

## **Tasks Overview**

### **Task 1: TCS3200 Color Sensor Interfac**
