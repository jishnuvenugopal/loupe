
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [3:0] count_reg;
reg [7:0] counter;
reg [1:0] state;
parameter IDLE = 2'b00, DETECT = 2'b01, COUNT = 2'b10, FINISH = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0000;
        count <= 4'b0000;
        counting <= 0;
        done <= 0;
        count_reg <= 4'b0000;
        counter <= 8'b00000000;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1 && data.shift == 1'b1 && data.shift.shift == 1'b0 && data.shift.shift.shift == 1'b1) begin
                    state <= DETECT;
                end else begin
                    state <= IDLE;
                end
            end
            DETECT: begin
                if (data != 1'b1) begin
                    delay <= {delay[2:0], data};
                    state <= COUNT;
                end
            end
            COUNT: begin
                if (counter < (delay + 1) * 1000) begin
                    counter <= counter + 1;
                    count_reg <= delay - counter[9:6];
                    counting <= 1;
                end else begin
                    state <= FINISH;
                end
            end
            FINISH: begin
                if (ack == 1) begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase

        if (state == IDLE) begin
            count_reg <= 4'b0000;
            counting <= 0;
        end

        if (state == COUNT) begin
            count <= count_reg;
        end else begin
            count <= count_reg;
        end

        if (state == FINISH) begin
            count <= 4'b0000;
            counting <= 0;
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

endmodule
