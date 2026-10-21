
module TopModule (
    input clk,
    input rst,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    reg [7:0] received_data;
    reg [2:0] byte_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            received_data <= 8'b0;
            byte_count <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3] == 1'b1) begin
                        state <= WAIT_FOR_START;
                        received_data <= in;
                        byte_count <= 3'b0;
                    end
                end
                WAIT_FOR_START: begin
                    if (in[3] == 1'b1) begin
                        state <= RECEIVE_MESSAGE;
                        received_data <= in;
                        byte_count <= 3'b0;
                    end
                end
                RECEIVE_MESSAGE: begin
                    received_data <= {received_data[7:0], in};
                    byte_count <= byte_count + 1'b1;
                    if (byte_count == 3'b10) begin
                        done <= 1'b1;
                        out_bytes <= received_data;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule
