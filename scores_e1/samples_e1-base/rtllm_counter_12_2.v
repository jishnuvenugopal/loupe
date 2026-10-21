
module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

    reg [3:0] count;
    reg [1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0000;
            counter <= 2'b00;
        end else begin
            if (valid_count) begin
                count <= count + 1;
                if (count == 4'd11) begin
                    count <= 4'b0000;
                end
            end else begin
                count <= count;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 4'b0000;
        end else begin
            if (valid_count) begin
                out <= count;
            end else begin
                out <= out;
            end
        end
    end

endmodule
