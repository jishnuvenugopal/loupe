
module sequence_detector (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg sequence_detected
);

    reg [3:0] state;
    reg [3:0] expected_sequence = 4'b1001;

    always @(posedge clk or negedge rst_n) begin
        if (rst_n) begin
            state <= 4'b0000;
            sequence_detected <= 1'b0;
        end else begin
            case (state)
                4'b0000: begin
                    if (data_in == 1'b1) begin
                        state <= 4'b0001;
                    end
                end
                4'b0001: begin
                    if (data_in == 1'b0) begin
                        state <= 4'b0010;
                    end
                end
                4'b0010: begin
                    if (data_in == 1'b1) begin
                        state <= 4'b0011;
                    end
                end
                4'b0011: begin
                    if (data_in == 1'b0) begin
                        state <= 4'b0100;
                    end
                end
                4'b0100: begin
                    if (data_in == 1'b1) begin
                        state <= 4'b0101;
                    end
                end
                4'b0101: begin
                    if (data_in == 1'b0) begin
                        state <= 4'b0110;
                    end
                end
                4'b0110: begin
                    if (data_in == 1'b1) begin
                        state <= 4'b0111;
                    end
                end
                4'b0111: begin
                    if (data_in == 1'b0) begin
                        state <= 4'b1000;
                        sequence_detected <= 1'b1;
                    end
                end
                default: state <= 4'b0000;
            endcase
        end
    end

endmodule
