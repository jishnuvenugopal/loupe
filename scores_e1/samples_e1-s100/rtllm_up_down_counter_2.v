
module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    reg [15:0] counter_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter_reg <= 16'b0;
        end else begin
            if (up_down) begin
                counter_reg <= counter_reg + 1'b1;
            end else begin
                counter_reg <= counter_reg - 1'b1;
            end
        end
    end

    assign count = counter_reg;

endmodule
