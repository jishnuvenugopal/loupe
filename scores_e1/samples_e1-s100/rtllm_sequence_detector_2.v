
module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

    
    typedef enum {IDLE, S1, S2, S3, S4} state_t;
    state_t current_state = IDLE;

    
    localparam SEQUENCE = 4'b1001;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            sequence_detected <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (data_in == SEQUENCE[0]) begin
                        current_state <= S1;
                    end
                end
                S1: begin
                    if (data_in == SEQUENCE[1]) begin
                        current_state <= S2;
                    end else begin
                        current_state <= IDLE;
                    end
                end
                S2: begin
                    if (data_in == SEQUENCE[2]) begin
                        current_state <= S3;
                    end else begin
                        current_state <= IDLE;
                    end
                end
                S3: begin
                    if (data_in == SEQUENCE[3]) begin
                        current_state <= S4;
                        sequence_detected <= 1;
                    end else begin
                        current_state <= IDLE;
                    end
                end
                default: begin
                    current_state <= IDLE;
                end
            endcase
        end
    end

endmodule
