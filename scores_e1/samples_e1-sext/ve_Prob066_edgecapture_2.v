
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] counter;
    reg [31:0] last_in;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            last_in <= 0;
            out <= 0;
        end else begin
            if (in != last_in) begin
                counter <= counter + 1;
                last_in <= in;
            end else begin
                counter <= counter;
            end
            out <= counter == 0 ? 1 : 0;
        end
    end

endmodule
