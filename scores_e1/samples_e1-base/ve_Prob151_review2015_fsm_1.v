
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

    reg [3:0] pattern;
    reg [3:0] shift_count;
    reg done_flag;
    reg ack_flag;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pattern <= 4'b0000;
            shift_count <= 4'b0000;
            done_flag <= 0;
            ack_flag <= 0;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            if (data == 4'b1101) begin
                pattern <= data;
                shift_count <= 0;
                done_flag <= 0;
                ack_flag <= 0;
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end else if (pattern == 4'b1101) begin
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    shift_ena <= 1;
                    counting <= 1;
                end
            end else if (counting == 1 && done_counting == 1) begin
                done_flag <= 1;
                ack_flag <= 1;
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end else if (ack_flag == 1) begin
                reset <= 1;
                pattern <= 4'b0000;
                shift_count <= 4'b0000;
                done_flag <= 0;
                ack_flag <= 0;
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
        end
    end

endmodule
