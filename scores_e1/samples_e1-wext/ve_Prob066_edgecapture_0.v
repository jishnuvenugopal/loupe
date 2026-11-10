
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] state;
    reg [31:0] change_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 32'b0;
            change_counter <= 0;
        end else begin
            if (in != state) begin
                state <= in;
                change_counter <= change_counter + 1;
            end else begin
                state <= state;
                change_counter <= change_counter;
            end
        end
    end

    always @(posedge clk) begin
        if (change_counter > 0) begin
            out <= 32'b1;
        end else begin
            out <= 32'b0;
        end
    end

endmodule
