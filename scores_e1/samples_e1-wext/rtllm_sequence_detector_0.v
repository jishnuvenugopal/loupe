
module sequence_detector (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg sequence_detected
);

    
    typedef enum {IDLE, S1, S2, S3, S4} state_t;
    state_t state;

    
    reg sequence_detected;

    
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in == 1'b1) begin
                        state <= S1;
                    end
                end
                S1: begin
                    if (data_in == 1'b0) begin
                        state <= S2;
                    end
                end
                S2: begin
                    if (data_in == 1'b1) begin
                        state <= S3;
                    end
                end
                S3: begin
                    if (data_in == 1'b0) begin
                        state <= S4;
                        sequence_detected <= 1'b1;
                    end
                end
                S4: begin
                    
                end
            endcase
        end
    end

endmodule
