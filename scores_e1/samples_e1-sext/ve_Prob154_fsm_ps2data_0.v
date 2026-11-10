
module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [2:0] state;
    reg [7:0] message;
    reg [2:0] byte_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            message <= 8'b00000000;
            byte_count <= 3'b000;
            out_bytes <= 24'b00000000;
            done <= 1'b0;
        end else begin
            case (state)
                3'b000: begin
                    if (in[3] == 1) begin
                        state <= 3'b001;
                        byte_count <= 3'b000;
                        message <= in;
                    end
                end
                3'b001: begin
                    if (byte_count == 2) begin
                        state <= 3'b010;
                        out_bytes <= message;
                        done <= 1'b1;
                    end else begin
                        byte_count <= byte_count + 1;
                        message[7:0] <= in;
                    end
                end
                3'b010: begin
                    if (byte_count == 3) begin
                        state <= 3'b000;
                        message <= 8'b00000000;
                        byte_count <= 3'b000;
                        out_bytes <= message;
                        done <= 1'b1;
                    end else begin
                        byte_count <= byte_count + 1;
                        message[7:0] <= in;
                    end
                end
                default: state <= 3'b000;
            endcase
        end
    end

endmodule
