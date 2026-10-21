
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] count;
    reg [31:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            state <= 0;
        end else begin
            if (state == 0 && in == 1) begin
                count <= 1;
                state <= 1;
            end else if (state == 1 && in == 0) begin
                count <= count + 1;
                state <= 0;
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 0;
        end else begin
            if (count == 0) begin
                out <= 1;
            end else begin
                out <= 0;
            end
        end
    end

endmodule
