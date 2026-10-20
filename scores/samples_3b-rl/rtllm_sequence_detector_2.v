
module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

    
    typedef enum {IDLE, S1, S2, S3, S4} state_t;
    reg [3:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in == 1'b1) begin
                        state <= S1;
                    end else begin
                        state <= IDLE;
                    end
                end
                S1: begin
                    if (data_in == 1'b0) begin
                        state <= S2;
                    end else begin
                        state <= IDLE;
                    end
                end
                S2: begin
                    if (data_in == 1'b0) begin
                        state <= S3;
                    end else begin
                        state <= IDLE;
                    end
                end
                S3: begin
                    if (data_in == 1'b0) begin
                        state <= S4;
                    end else begin
                        state <= IDLE;
                    end
                end
                S4: begin
                    if (data_in == 1'b1) begin
                        sequence_detected <= 1;
                        state <= S4;
                    end else begin
                        state <= IDLE;
                        sequence_detected <= 0;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
