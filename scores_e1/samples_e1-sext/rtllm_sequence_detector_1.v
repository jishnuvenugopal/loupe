
module sequence_detector (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg sequence_detected
);

    reg [3:0] state;
    reg [3:0] expected_sequence;

    initial begin
        state = IDLE;
        expected_sequence = 4'b1001;
        sequence_detected = 0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 0;
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
                    if (data_in == 1'b0) begin
                        state <= S3;
                    end
                end
                S3: begin
                    if (data_in == 1'b1) begin
                        state <= S4;
                        sequence_detected <= 1'b1;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
