# Simulation and Testbenches

This directory contains the verification environment for the temperature sensor system. 

## Files

*   `testbench.sv`
    *   **Description**: The primary testbench for simulating the `TopModule` and its sub-components. 

## Simulation Strategy
The testbench is designed to verify the digital logic before synthesizing to the FPGA. It performs the following functions:
1.  **Clock Generation**: Simulates the 100MHz input clock.
2.  **Reset Initialization**: Applies a system reset to initialize all state machines.
3.  **I2C Mocking**: Simulates the behavior of the ADT7420 sensor by driving the `SDA` line with predefined temperature data to verify that the `I2C_ADT7420_Reader.sv` decodes it correctly.
4.  **PWM Observation**: Monitors the outputs of the RGB LED pins to ensure the duty cycle correctly corresponds to the injected mock temperature data.

## Usage
Run this testbench using the Vivado Simulator (XSim) or any compatible SystemVerilog simulator (e.g., ModelSim). Ensure the simulation runs long enough to capture several full I2C transaction cycles.
