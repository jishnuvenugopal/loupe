
module TopModule (
    input wire [99:0] in,
    output reg [99:0] out_and,
    output reg [99:0] out_or,
    output reg [99:0] out_xor
);


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        out_and <= 100'b0;
    end else begin
        out_and <= in & in;
    end
end


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        out_or <= 100'b0;
    end else begin
        out_or <= in | in;
    end
end


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        out_xor <= 100'b0;
    end else begin
        out_xor <= in ^ in;
    end
end

endmodule
