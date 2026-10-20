
module TopModule (
    input clk,
    input reset,
    output [3:0] ena,
    output [15:0] q
);

reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

assign ena[1] = (ones == 4'd9) && ~reset;
assign ena[2] = (tens == 4'd9) && (ones == 4'd9) && ~reset;
assign ena[3] = (hundreds == 4'd9) && (tens == 4'd9) && (ones == 4'd9) && ~reset;
assign ena[0] = 1'b0;

assign q = {thousands, hundreds, tens, ones};

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
    end else begin
        if (ones == 4'd9)
            ones <= 4'd0;
        else
            ones <= ones + 1;
    end
end

always @(posedge clk) begin
    if (reset) begin
        tens <= 4'd0;
    end else if (ena[1]) begin
        if (tens == 4'd9)
            tens <= 4'd0;
        else
            tens <= tens + 1;
    end
end

always @(posedge clk) begin
    if (reset) begin
        hundreds <= 4'd0;
    end else if (ena[2]) begin
        if (hundreds == 4'd9)
            hundreds <= 4'd0;
        else
            hundreds <= hundreds + 1;
    end
end

always @(posedge clk) begin
    if (reset) begin
        thousands <= 4'd0;
    end else if (ena[3]) begin
        if (thousands == 4'd9)
            thousands <= 4'd0;
        else
            thousands <= thousands + 1;
    end
end

endmodule
