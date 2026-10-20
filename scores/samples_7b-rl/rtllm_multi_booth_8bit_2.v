
module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output [15:0] p,
    output reg rdy
);

    reg [15:0] multiplier;
    reg [15:0] multiplicand;
    reg [4:0] ctr;
    reg [15:0] product;

    
    assign p = product;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
            multiplier <= { {8{a[7]}}, a };
            multiplicand <= { {8{b[7]}}, b };
            ctr <= 5'd0;
            product <= 16'd0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 5'd16) begin
                
                if (multiplier[ctr]) begin
                    product <= product + multiplicand;
                end
                
                multiplicand <= multiplicand << 1;
                
                ctr <= ctr + 1;
            end else begin
                
                rdy <= 1'b1;
            end
        end
    end

endmodule
