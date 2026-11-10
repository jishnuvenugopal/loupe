
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input reg ack
);

    reg [3:0] delay;
    reg [3:0] remaining_time;
    reg [3:0] state;
    reg [3:0] next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 4'b0000;
            count <= 4'b0000;
            remaining_time <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                4'b0000: begin
                    if (data == 4'b1101) begin
                        delay <= 4'b0000;
                        next_state <= 4'b0001;
                    end else begin
                        next_state <= 4'b0000;
                    end
                end
                4'b0001: begin
                    delay <= delay + 1;
                    next_state <= 4'b0010;
                end
                4'b0010: begin
                    remaining_time <= remaining_time - 1;
                    next_state <= 4'b0011;
                end
                4'b0011: begin
                    if (remaining_time == 0) begin
                        done <= 1'b1;
                        next_state <= 4'b0000;
                    end else begin
                        next_state <= 4'b0010;
                    end
                end
                4'b0100: begin
                    if (ack == 1) begin
                        state <= 4'b0000;
                        count <= 4'b0000;
                        remaining_time <= 4'b0000;
                        counting <= 1'b0;
                        done <= 1'b0;
                    end else begin
                        next_state <= 4'b0100;
                    end
                end
                default: begin
                    next_state <= 4'b0000;
                end
            endcase
            state <= next_state;
        end
    end

endmodule
