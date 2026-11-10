
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
    reg [3:0] shift_register;
    reg [3:0] shift_counter;
    reg [3:0] shift_flag;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= idle;
            count <= 4'b0000;
            remaining_time <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
            shift_register <= 4'b0000;
            shift_counter <= 4'b0000;
            shift_flag <= 1'b0;
        end else begin
            case (state)
                idle: begin
                    if (data == 4'b1101) begin
                        state <= counting;
                        delay <= shift_register;
                        shift_register <= 4'b0000;
                        shift_counter <= 4'b0000;
                        shift_flag <= 1'b1;
                    end
                end
                counting: begin
                    remaining_time <= remaining_time - 1;
                    if (remaining_time == 0) begin
                        state <= done;
                        done <= 1'b1;
                    end
                end
                done: begin
                    if (ack == 1) begin
                        state <= idle;
                        count <= 4'b0000;
                        remaining_time <= 4'b0000;
                        counting <= 1'b0;
                        done <= 1'b0;
                        shift_register <= 4'b0000;
                        shift_counter <= 4'b0000;
                        shift_flag <= 1'b0;
                    end
                end
            endcase
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_register <= 4'b0000;
            shift_counter <= 4'b0000;
            shift_flag <= 1'b0;
        end else begin
            if (shift_flag) begin
                shift_register <= {shift_register[3:0], data};
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4) begin
                    shift_flag <= 1'b0;
                end
            end
        end
    end

endmodule
