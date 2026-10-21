
module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    reg [3:0] pattern = 4'b1101;
    reg [3:0] shift_count = 0;
    reg [3:0] done_count = 0;
    reg done_flag = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pattern <= 4'b1101;
            shift_count <= 0;
            done_count <= 0;
            done_flag <= 0;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            if (data == pattern) begin
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    shift_ena <= 1;
                    done_count <= done_count + 1;
                end
            end else if (done_count == 4) begin
                done_flag <= 1;
                done <= 1;
                shift_ena <= 0;
                counting <= 0;
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            if (done_flag) begin
                done_flag <= 0;
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
        end
    end

endmodule
