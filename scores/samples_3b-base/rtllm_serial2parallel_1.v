
module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    
    reg [3:0] cnt;

    
    enum {IDLE, COLLECTING, OUTPUTTING} state;

    
    reg [7:0] serial_data;

    
    reg [1:0] state_reg;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'b0;
            state_reg <= IDLE;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end else begin
            case (state_reg)
                IDLE: begin
                    if (din_valid) begin
                        state_reg <= COLLECTING;
                        cnt <= 4'b0;
                    end
                end
                COLLECTING: begin
                    if (cnt == 7) begin
                        state_reg <= OUTPUTTING;
                        serial_data <= din_serial;
                    end else begin
                        serial_data[7 - cnt] <= din_serial;
                        cnt <= cnt + 1;
                    end
                end
                OUTPUTTING: begin
                    dout_parallel <= serial_data;
                    dout_valid <= 1'b1;
                    state_reg <= IDLE;
                end
            endcase
        end
    end

endmodule
