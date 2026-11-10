
module TopModule (
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [7:0] s,
    output reg overflow
);

    
    reg [7:0] sum;

    always @(*) begin
        sum = a + b;
    end

    
    always @(*) begin
        if (a >= 0 && b >= 0 && sum < 0) begin
            overflow = 1'b1;
        end else if (a < 0 && b < 0 && sum >= 0) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end

    
    assign s = sum;

endmodule
