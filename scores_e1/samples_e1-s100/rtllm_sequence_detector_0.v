
module sequence_detector (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg sequence_detected
);

    
    typedef enum {IDLE, S1, S2, S3, S4} state_t;
    state_t state;

    
    reg [3:0] sequence;
    reg [3:0] expected_sequence = 4'b1001;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in == 1'b1) begin
                        state <= S1;
                        sequence <= 4'b0001;
                    end
                end
                S1: begin
                    if (data_in == 1'b0) begin
                        state <= S2;
                        sequence <= 4'b0010;
                    end
                end
                S2: begin
                    if (data_in == 1'b0) begin
                        state <= S3;
                        sequence <= 4'b0011;
                    end
                end
                S3: begin
                    if (data_in == 1'b0) begin
                        state <= S4;
                        sequence <= 4'b0100;
                        sequence_detected <= 1'b1;
                    end
                end
                default: begin
                    state <= IDLE;
                    sequence <= 4'b0000;
                end
            endcase
        end
    end

endmodule
