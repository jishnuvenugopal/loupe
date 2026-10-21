
module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

always @(a, b, c, d) begin
    
    if (a < b) begin
        min <= a;
    end else begin
        min <= b;
    end

    
    if (min < c) begin
        min <= min;
    end else begin
        min <= c;
    end

    
    if (min < d) begin
        min <= min;
    end else begin
        min <= d;
    end
end

endmodule
