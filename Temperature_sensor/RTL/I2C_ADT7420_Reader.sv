module i2c_adt7420 (
    input wire clk,
    input wire rst,
    input wire i2c_en,
    output reg scl,
    inout wire sda,
    output reg [12:0] temp_data, // 13-bit temperature value
    output reg valid_data
);
    // ADT7420 I2C Address (0x4B) + Read Bit (1) = 8'b10010111 (0x97)
    localparam [7:0] ADDR_READ = 8'h97;

    // FSM States
    localparam IDLE=0, START=1, SEND_ADDR=2, ACK1=3, READ_MSB=4, ACK2=5, READ_LSB=6, NACK=7, STOP=8;
    
    reg [3:0] state = IDLE;
    reg [3:0] bit_cnt = 0;
    reg [7:0] shift_tx = ADDR_READ;
    reg [15:0] shift_rx = 0;
    
    reg sda_out = 1;
    reg sda_dir = 1; // 1 = output, 0 = input
    
    assign sda = (sda_dir) ? sda_out : 1'bz;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            scl <= 1;
            sda_out <= 1;
            sda_dir <= 1;
            valid_data <= 0;
        end else if (i2c_en) begin
            case (state)
                IDLE: begin
                    scl <= 1; sda_out <= 1; sda_dir <= 1; valid_data <= 0;
                    state <= START;
                end
                START: begin
                    sda_out <= 0; // Pull SDA low while SCL is high
                    shift_tx <= ADDR_READ;
                    bit_cnt <= 7;
                    state <= SEND_ADDR;
                end
                SEND_ADDR: begin
                    scl <= ~scl; // Toggle SCL
                    if (scl == 0) begin
                        sda_out <= shift_tx[bit_cnt];
                        if (bit_cnt == 0) begin
                            state <= ACK1;
                            sda_dir <= 0; // Release SDA to read ACK
                        end else bit_cnt <= bit_cnt - 1;
                    end
                end
                ACK1: begin
                    scl <= ~scl;
                    if (scl == 1) state <= READ_MSB; // Wait for ACK (assume it arrives for simplicity)
                    if (scl == 0) begin bit_cnt <= 7; end
                end
                READ_MSB: begin
                    scl <= ~scl;
                    if (scl == 1) shift_rx[15:8] <= {shift_rx[14:8], sda}; // Sample on high
                    if (scl == 0) begin
                        if (bit_cnt == 0) begin state <= ACK2; sda_dir <= 1; sda_out <= 0; end
                        else bit_cnt <= bit_cnt - 1;
                    end
                end
                ACK2: begin
                    scl <= ~scl; // Send ACK to sensor
                    if (scl == 0) begin state <= READ_LSB; bit_cnt <= 7; sda_dir <= 0; end
                end
                READ_LSB: begin
                    scl <= ~scl;
                    if (scl == 1) shift_rx[7:0] <= {shift_rx[6:0], sda};
                    if (scl == 0) begin
                        if (bit_cnt == 0) begin state <= NACK; sda_dir <= 1; sda_out <= 1; end
                        else bit_cnt <= bit_cnt - 1;
                    end
                end
                NACK: begin
                    scl <= ~scl; // Send NACK (SDA high)
                    if (scl == 0) state <= STOP;
                end
                STOP: begin
                    scl <= 1;
                    if (scl == 1) begin
                        sda_out <= 1; // Pull SDA high while SCL high
                        // Extract 13-bit temp (Top 13 bits of the 16-bit register)
                        temp_data <= shift_rx[15:3]; 
                        valid_data <= 1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule