
module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    
    reg [15:0] multiplier;
    reg [15:0] multiplicand;

    
    reg [4:0] ctr;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
            multiplier <= {{8{a[7]}}, a};
            multiplicand <= {{8{b[7]}}, b};
            ctr <= 5'b0;
            p <= 16'b0;
            rdy <= 1'b0;
        end else begin
            
            ctr <= ctr + 1'b1;

            
            if (ctr < 16) begin
                
                multiplicand <= {multiplicand[15:1], multiplicand[0]};

                
                if (multiplier[ctr] == 1'b1) begin
                    
                    p <= p + multiplicand;
                end else if (multiplier[ctr] == 1'b0) begin
                    
                    p <= p - multiplicand;
                end
            end else begin
                
                rdy <= 1'b1;
            end
        end
    end

endmodule
