
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] state;
reg [31:0] counter;
reg [31:0] last_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 32'b0;
        counter <= 32'b0;
        last_state <= 32'b0;
    end else begin
        state <= in;
        if (state != last_state) begin
            counter <= counter + 1;
            last_state <= state;
        end else begin
            counter <= counter;
        end
        if (state == 32'b0 && counter == 1) begin
            out <= 32'b1;
            counter <= 0;
        end else begin
            out <= 32'b0;
        end
    end
end

endmodule
