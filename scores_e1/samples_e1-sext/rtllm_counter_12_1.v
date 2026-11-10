
module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

    reg [3:0] counter;

    always @(posedge clk or posedge rst_n) begin
        if (!rst_n) begin
            counter <= 4'b0000;
            out <= 4'b0000;
        end else begin
            if (valid_count) begin
                if (counter == 4'b1111) begin
                    counter <= 4'b0000;
                end else begin
                    counter <= counter + 1;
                end
                out <= counter;
            end else begin
                out <= counter;
            end
        end
    end

endmodule
