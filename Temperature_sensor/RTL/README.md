# Temperature Sensor System

## Overview
This repository contains the hardware description, testbenches, and constraints for a Temperature Sensor Monitoring System. The design is implemented in SystemVerilog and is targeted for the Nexys A7-100T FPGA development board. 

The system interfaces with the onboard ADT7420 temperature sensor using the I2C protocol and translates the temperature readings into a visual output using the board's RGB LEDs, driven by a custom Pulse Width Modulation (PWM) controller.

## Repository Structure
* **/RTL**: Contains all synthesizable SystemVerilog source files (`.sv`).
* **/Testbench**: Contains simulation files for verifying the RTL logic.
* **/Constraints**: Contains the Xilinx Design Constraints (`.xdc`) file for pin assignments and timing.

## Toolchain
* **Language**: SystemVerilog
* **Synthesis & Implementation**: Xilinx Vivado
* **Target Hardware**: Digilent Nexys A7-100T

## Author
**Risitha Wickramasingha**  
Department of Electrical and Information Engineering, University of Ruhuna
