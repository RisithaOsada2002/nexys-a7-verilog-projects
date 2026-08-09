module top_temp_monitor (
    input wire clk_100mhz,
    input wire rst_btn,       // Active high reset
    input wire [7:0] sw,      // 8 slide switches for temperature threshold
    output wire tmp_scl,
    inout wire tmp_sda,
    output wire led16_r,
    output wire led16_g,
    output wire led16_b
);
    wire i2c_en, pwm_en;
    wire [12:0] current_temp;
    wire valid_data;
    wire alarm;

    // The ADT7420 13-bit format means the LSB is 0.0625 °C. 
    // To compare our switches (whole degrees C) with the sensor data, 
    // we shift the switch value left by 4 (multiply by 16).
    wire [12:0] threshold = {1'b0, sw, 4'b0000}; 

    // Comparator Logic
    assign alarm = (current_temp >= threshold) ? 1'b1 : 1'b0;

    // Instantiations
    clk_divider clk_inst (
        .clk_100mhz(clk_100mhz),
        .rst(rst_btn),
        .i2c_en(i2c_en),
        .pwm_en(pwm_en)
    );

    i2c_adt7420 sensor_inst (
        .clk(clk_100mhz),
        .rst(rst_btn),
        .i2c_en(i2c_en),
        .scl(tmp_scl),
        .sda(tmp_sda),
        .temp_data(current_temp),
        .valid_data(valid_data)
    );

    pwm_rgb rgb_inst (
        .clk(clk_100mhz),
        .pwm_en(pwm_en),
        .alarm(alarm),
        .led_r(led16_r),
        .led_g(led16_g),
        .led_b(led16_b)
    );

endmodule