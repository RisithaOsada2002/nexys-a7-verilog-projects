module pwm_rgb (
    input wire clk,
    input wire pwm_en,
    input wire alarm,     // 1 = Red, 0 = Green
    output reg led_r,
    output reg led_g,
    output wire led_b     // Tie to 0, we don't need blue
);
    reg [7:0] pwm_counter = 0;
    assign led_b = 1'b0; 

    always @(posedge clk) begin
        if (pwm_en) begin
            pwm_counter <= pwm_counter + 1;
            
            if (alarm) begin
                // Turn RED on (e.g., 75% duty cycle)
                led_r <= (pwm_counter < 192) ? 1'b1 : 1'b0;
                led_g <= 1'b0;
            end else begin
                // Turn GREEN on (e.g., 50% duty cycle)
                led_r <= 1'b0;
                led_g <= (pwm_counter < 128) ? 1'b1 : 1'b0;
            end
        end
    end
endmodule