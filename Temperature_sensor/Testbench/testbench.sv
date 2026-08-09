`timescale 1ns / 1ps

module tb_top_temp_monitor;

    // Inputs
    reg clk_100mhz;
    reg rst_btn;
    reg [7:0] sw;

    // Outputs
    wire tmp_scl;
    wire led16_r;
    wire led16_g;
    wire led16_b;

    // Bidirectional
    wire tmp_sda;

    // Simulate the physical pull-up resistor on the I2C bus
    pullup(tmp_sda);

    // Instantiate the Unit Under Test (UUT)
    top_temp_monitor uut (
        .clk_100mhz(clk_100mhz), 
        .rst_btn(rst_btn), 
        .sw(sw), 
        .tmp_scl(tmp_scl), 
        .tmp_sda(tmp_sda), 
        .led16_r(led16_r), 
        .led16_g(led16_g), 
        .led16_b(led16_b)
    );

    // Clock Generation: 100 MHz (10ns period)
    always #5 clk_100mhz = ~clk_100mhz;

    initial begin
        // Initialize Inputs
        clk_100mhz = 0;
        rst_btn = 1;
        sw = 8'b00011110; // Set threshold to 30 degrees C (30 in binary)

        // Wait 100 ns for global reset to finish
        #100;
        
        // Release reset
        rst_btn = 0;

        // The simulation needs to run for a while because our clock divider 
        // slows the 100MHz clock down to 200kHz for the I2C FSM.
        // Let it run for 2 milliseconds to see a full I2C transaction.
        #2000000; 

        $display("Simulation complete. Check the waveform for I2C activity.");
        $finish;
    end
    
    // Optional: A block to mock the sensor's ACK response 
    // This watches the SCL line and pulls SDA low when it expects an ACK
    // (Note: This is a very basic mock just for visual waveform confirmation)
    /*
    always @(negedge tmp_scl) begin
        // Add logic here if you want to force tmp_sda = 0 to simulate ACKs
        // or feed dummy temperature data back to the FPGA.
    end
    */

endmodule