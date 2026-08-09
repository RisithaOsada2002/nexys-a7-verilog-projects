# Physical Constraints

This directory contains the Xilinx Design Constraints (XDC) required to map the RTL ports to the physical pins on the FPGA.

## Files

*   `master.xdc`
    *   **Description**: The master constraints file for the Nexys A7-100T.

## Pin Mappings
The constraints file maps the following key signals:
*   **System Clock**: Mapped to the 100MHz oscillator (Pin `E3`).
*   **Reset**: Mapped to a push button (typically `CPU_RESET` or `BTNC`).
*   **I2C SCL & SDA**: Mapped to the specific FPGA pins connected to the onboard ADT7420 sensor's I2C bus.
*   **RGB LEDs**: Mapped to the multi-color LED pins (e.g., `LED16_R`, `LED16_G`, `LED16_B`).

*Note: Ensure the standard 3.3V logic levels (`LVCMOS33`) are specified for these I/O ports within the XDC file.*
