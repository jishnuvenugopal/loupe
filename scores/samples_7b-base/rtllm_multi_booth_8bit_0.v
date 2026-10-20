
module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [15:0] p,
    output reg rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [15:0] product;
reg [4:0] ctr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        product <= 0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            multiplicand <= {multiplicand[14:0], 1'b0};
 
            if (multiplier[ctr] == 2'b11) begin
                product <= product + multiplicand;
 
            end else if (multiplier[ctr] == 2'b00) begin
                product <= product - multiplicand;
 
            end
            ctr <= ctr + 1;
        end else begin
            rdy <= 1;
 
        end
    end
end

assign p = product;

endmodule
