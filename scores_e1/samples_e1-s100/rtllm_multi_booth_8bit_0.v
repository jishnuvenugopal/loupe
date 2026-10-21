
module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [7:0] multiplier;
reg [7:0] multiplicand;
reg [4:0] ctr;
reg [15:0] product;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        ctr <= 5'b0;
        product <= 16'b0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            multiplicand <= {multiplicand[6:0], 1'b0};
            if (multiplier[ctr]) begin
                product <= product + multiplicand;
            end
            ctr <= ctr + 1'b1;
        end else begin
            rdy <= 1'b1;
        end
    end
end

assign p = product;
assign rdy = rdy;

endmodule
