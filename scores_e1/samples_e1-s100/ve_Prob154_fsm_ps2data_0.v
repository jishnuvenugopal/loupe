
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done,
    output reg [23:0] out_bytes
);

    reg [2:0] state;
    reg [7:0] byte_count;
    reg [7:0] message;
    reg [7:0] message_byte_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            byte_count <= 8'b00000000;
            message <= 8'b00000000;
            message_byte_count <= 8'b00000000;
            done <= 1'b0;
            out_bytes <= 24'b0000000000000000;
        end else begin
            case (state)
                3'b000: begin
                    if (in[3] == 1'b1) begin
                        state <= 3'b001;
                        byte_count <= 8'b00000000;
                        message_byte_count <= 8'b00000000;
                    end
                end
                3'b001: begin
                    byte_count <= byte_count + 1'b1;
                    message_byte_count <= message_byte_count + 1'b1;
                    message <= message << 1'b1 | in;
                    if (byte_count == 3'b111) begin
                        state <= 3'b010;
                        message_byte_count <= 8'b00000000;
                    end
                end
                3'b010: begin
                    done <= 1'b1;
                    out_bytes <= message[23:16] << 8 | message[15:8];
                    state <= 3'b000;
                    byte_count <= 8'b00000000;
                    message_byte_count <= 8'b00000000;
                end
            endcase
        end
    end

endmodule
