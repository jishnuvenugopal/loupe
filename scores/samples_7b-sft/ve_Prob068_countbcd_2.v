
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

assign q = {thousands, hundreds, tens, ones};

assign ena[1] = (ones == 4'd9);
assign ena[2] = (tens == 4'd9) && ena[1];
assign ena[3] = (hundreds == 4'd9) && ena[2];
assign ena[0] = 1'b0;

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        
        if (ones == 4'd9) begin
            ones <= 4'd0;
        end else begin
            ones <= ones + 4'd1;
        end

        
        if (ena[1]) begin
            if (tens == 4'd9) begin
                tens <= 4'd0;
            end else begin
                tens <= tens + 4'd1;
            end
        end

        
        if (ena[2]) begin
            if (hundreds == 4'd9) begin
                hundreds <= 4'd0;
            end else begin
                hundreds <= hundreds + 4'd1;
            end
        end

        
        if (ena[3]) begin
            if (thousands == 4'd9) begin
                thousands <= 4'd0;
            end else begin
                thousands <= thousands + 4'd1;
            end
        end
    end
end

endmodule
