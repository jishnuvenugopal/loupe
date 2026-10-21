
module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

    
    reg [1:0] state;
    reg [3:0] sequence;

    
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            state <= 2'b00;
            sequence <= 4'b0000;
            sequence_detected <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    if (data_in == 1'b1) begin
                        state <= 2'b01;
                        sequence <= sequence << 1;
                        sequence[0] <= data_in;
                    end else begin
                        state <= 2'b00;
                    end
                end
                2'b01: begin
                    if (data_in == 1'b0) begin
                        state <= 2'b00;
                        sequence_detected <= 1'b0;
                    end else begin
                        state <= 2'b10;
                        sequence <= sequence << 1;
                        sequence[0] <= data_in;
                    end
                end
                2'b10: begin
                    if (data_in == 1'b1) begin
                        state <= 2'b11;
                        sequence <= sequence << 1;
                        sequence[0] <= data_in;
                    end else begin
                        state <= 2'b10;
                    end
                end
                2'b11: begin
                    if (data_in == 1'b0) begin
                        state <= 2'b00;
                        sequence_detected <= 1'b0;
                    end else begin
                        state <= 2'b00;
                        sequence_detected <= 1'b1;
                    end
                end
            endcase
        end
    end

    
    assign sequence_detected = state == 2'b11;

endmodule
