# RTL (Register Transfer Level) Sources

This directory contains the synthesizable SystemVerilog modules that make up the core logic of the temperature monitoring system.

## Module Descriptions

*   `TopModule.sv`
    *   **Description**: The top-level module that instantiates and wires together the clock divider, the I2C sensor reader, and the PWM LED controller. It interfaces directly with the FPGA's physical pins.
*   `clockdivider.sv`
    *   **Description**: Takes the 100MHz system clock from the Nexys A7 and scales it down to the appropriate frequencies required by the I2C protocol (typically 100 kHz or 400 kHz) and the PWM controller.
*   `I2C_ADT7420_Reader.sv`
    *   **Description**: A custom I2C master controller designed to communicate with the ADT7420 temperature sensor. It handles the START, STOP, ACK/NACK conditions, and data shifting to read the multi-byte temperature registers.
*   `PWM_RGB_Controller.sv`
    *   **Description**: Generates Pulse Width Modulation signals to drive the RGB LEDs. It adjusts the duty cycle for the Red, Green, and Blue channels based on the temperature data received from the sensor (e.g., shifting from blue for cold to red for hot).
