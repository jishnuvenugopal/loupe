
module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [5:0] ctr;
reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [15:0] product;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ctr <= 0;
        multiplicand <= {{8{a[7]}}, a};
        multiplier <= {{8{b[7]}}, b};
        product <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            multiplicand <= {multiplicand[15:0], 1'b0};
            if (multiplier[ctr] == 1'b1) begin
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
