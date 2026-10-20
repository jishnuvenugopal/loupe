
module TopModule(clk, reset, ena, q);
    input clk;
    input reset;
    output reg [3:0] ena;
    output reg [15:0] q;

    reg [3:0] digit_ones;
    reg [3:0] digit_tens;
    reg [3:0] digit_hundreds;
    reg [3:0] digit_thousands;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'b0;
        end else begin
            q <= q + 1;
        end
    end

    
    assign digit_ones = q[3:0];
    assign digit_tens = q[7:4];
    assign digit_hundreds = q[11:8];
    assign digit_thousands = q[15:12];

    
    assign ena[0] = (digit_hundreds || digit_tens || digit_ones);
    assign ena[1] = (digit_tens || digit_ones);
    assign ena[2] = digit_ones;
    assign ena[3] = 1'b0;
 

    
    
endmodule
