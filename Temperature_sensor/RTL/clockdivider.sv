module clk_divider (
    input wire clk_100mhz,
    input wire rst,
    output reg i2c_en,  // 200 kHz enable pulse
    output reg pwm_en   // ~1 MHz enable pulse for smooth LED PWM
);
    reg [8:0] i2c_counter;
    reg [6:0] pwm_counter;

    always @(posedge clk_100mhz or posedge rst) begin
        if (rst) begin
            i2c_counter <= 0;
            pwm_counter <= 0;
            i2c_en <= 0;
            pwm_en <= 0;
        end else begin
            // 100MHz / 500 = 200kHz
            if (i2c_counter == 499) begin
                i2c_counter <= 0;
                i2c_en <= 1;
            end else begin
                i2c_counter <= i2c_counter + 1;
                i2c_en <= 0;
            end

            // 100MHz / 100 = 1MHz
            if (pwm_counter == 99) begin
                pwm_counter <= 0;
                pwm_en <= 1;
            end else begin
                pwm_counter <= pwm_counter + 1;
                pwm_en <= 0;
            end
        end
    end
endmodule