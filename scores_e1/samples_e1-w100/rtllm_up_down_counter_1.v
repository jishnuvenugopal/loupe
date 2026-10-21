
module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    reg [15:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
        end else if (up_down) begin
            counter <= counter + 1;
        end else begin
            counter <= counter - 1;
        end
    end

    assign count = counter;

endmodule
