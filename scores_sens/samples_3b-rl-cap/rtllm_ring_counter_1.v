
module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [8:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 9'b0000_0000_01;
        end else begin
            counter <= counter + 1;
            if (counter == 9'b1000_0000_00) begin
                counter <= 9'b0000_0000_01;
            end
        end
    end

    assign out = counter[7:0];

endmodule
