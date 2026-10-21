
module TopModule (
    input clk,
    input reset,
    input data,
    output reg count,
    output reg counting,
    output reg done,
    input reg ack
);

    reg [3:0] state;
    reg [3:0] counter;
    reg timeout;
    reg acknowledged;
    reg resetting;
    reg searching;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 4'b0000;
            counter <= 4'b0000;
            timeout <= 0;
            acknowledged <= 0;
            resetting <= 0;
            searching <= 0;
        end else begin
            case (state)
                4'b0000: begin
                    if (data == 4'b1101) begin
                        state <= 4'b0001;
                        counter <= 4'b0000;
                        searching <= 1;
                    end
                end
                4'b0001: begin
                    if (counter < 4'b1000) begin
                        counter <= counter + 1;
                    end else begin
                        state <= 4'b0010;
                        timeout <= 1;
                    end
                end
                4'b0010: begin
                    if (timeout) begin
                        state <= 4'b0000;
                        timeout <= 0;
                        acknowledged <= 1;
                        searching <= 0;
                    end
                end
                4'b0011: begin
                    state <= 4'b0000;
                    timeout <= 0;
                    acknowledged <= 0;
                    resetting <= 1;
                end
            endcase
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000;
        end else begin
            count <= counter;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counting <= 0;
        end else begin
            counting <= counting;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
        end else begin
            done <= done;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack <= 0;
        end else begin
            ack <= ack;
        end
    end

endmodule
