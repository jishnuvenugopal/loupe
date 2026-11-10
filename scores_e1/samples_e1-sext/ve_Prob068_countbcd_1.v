
module TopModule (
    input clk,
    input reset,
    input ena,
    output reg [15:0] q,
    output reg [3:0] ena
);

    reg [3:0] digit_counter;
    reg [3:0] next_digit;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            digit_counter <= 4'b0000;
            next_digit <= 4'b0000;
            ena <= 4'b0000;
        end else begin
            if (ena) begin
                next_digit <= digit_counter + 1'b1;
                if (next_digit == 4'b1000) begin
                    next_digit <= 4'b0000;
                end
            end
            digit_counter <= next_digit;
            ena <= 4'b0000;
        end
    end

    assign q = digit_counter;
    assign ena = digit_counter[3];

endmodule
