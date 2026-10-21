
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] ff;
    reg [31:0] counter;
    reg [31:0] prev_in;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ff <= 32'b1;
            counter <= 0;
            prev_in <= 32'b0;
        end else begin
            if (in != prev_in) begin
                ff <= 32'b0;
                counter <= counter + 1;
            end else begin
                ff <= ff;
                counter <= counter;
            end
            prev_in <= in;
        end
    end

    always @(posedge clk) begin
        out <= ff;
    end

endmodule
