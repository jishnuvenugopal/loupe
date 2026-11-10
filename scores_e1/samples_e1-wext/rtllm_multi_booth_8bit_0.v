
module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] product;
reg [4:0] ctr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= {{8{a[7]}}, a};
        product <= {{8{b[7]}}, b};
        ctr <= 5'b0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            if (multiplier[ctr] == 1'b1) begin
                product <= product + multiplicand;
            end
            ctr <= ctr + 1'b1;
        end else begin
            rdy <= 1'b1;
        end
    end
end

endmodule
