
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] state;
    reg [31:0] counter;
    reg change_detected;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 32'b0;
            counter <= 0;
            change_detected <= 0;
        end else begin
            if (state == in) begin
                counter <= counter + 1;
                change_detected <= 1;
            end else begin
                state <= in;
                counter <= 0;
                change_detected <= 0;
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            if (change_detected) begin
                out <= out | 1'b1;
                change_detected <= 0;
            end else begin
                out <= out;
            end
        end
    end

endmodule
