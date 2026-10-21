
module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            min <= 8'b10000000;
 
        end else begin
            min <= $min(a, b, c, d);
 
        end
    end

endmodule
