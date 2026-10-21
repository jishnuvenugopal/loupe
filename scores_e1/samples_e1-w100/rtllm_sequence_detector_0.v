
module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

    
    reg [1:0] state;
    reg [3:0] sequence;
    reg [3:0] expected_sequence;
    reg [3:0] detected_sequence;

    
    initial begin
        state = IDLE;
        sequence = 0;
        expected_sequence = 1001;
        detected_sequence = 0;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence <= 0;
            detected_sequence <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in == 1'b1) begin
                        sequence = 0;
                        state = S1;
                    end
                end
                S1: begin
                    if (data_in == 1'b0) begin
                        sequence = 0;
                        state = IDLE;
                    end else begin
                        sequence = sequence << 1;
                        sequence = sequence | 1'b1;
                        if (sequence == expected_sequence) begin
                            sequence_detected = 1'b1;
                            state = IDLE;
                        end
                    end
                end
                S2: begin
                    if (data_in == 1'b0) begin
                        sequence = 0;
                        state = IDLE;
                    end else begin
                        sequence = sequence << 1;
                        sequence = sequence | 1'b1;
                        if (sequence == expected_sequence) begin
                            sequence_detected = 1'b1;
                            state = IDLE;
                        end
                    end
                end
                S3: begin
                    if (data_in == 1'b0) begin
                        sequence = 0;
                        state = IDLE;
                    end else begin
                        sequence = sequence << 1;
                        sequence = sequence | 1'b1;
                        if (sequence == expected_sequence) begin
                            sequence_detected = 1'b1;
                            state = IDLE;
                        end
                    end
                end
                S4: begin
                    if (data_in == 1'b0) begin
                        sequence = 0;
                        state = IDLE;
                    end else begin
                        sequence = sequence << 1;
                        sequence = sequence | 1'b1;
                        if (sequence == expected_sequence) begin
                            sequence_detected = 1'b1;
                            state = IDLE;
                        end
                    end
                end
            endcase
        end
    end

endmodule
