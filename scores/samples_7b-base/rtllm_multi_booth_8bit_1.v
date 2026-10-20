
module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [15:0] temp_p;
reg [4:0] ctr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        p <= 16'b0;
        ctr <= 5'b0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            
            multiplicand <= {1'b0, multiplicand[15:1]};
            
            
            case (multiplier[15:14])
                2'b00: temp_p <= p;
 
                2'b01: temp_p <= p + multiplicand;
 
                2'b10: temp_p <= p - multiplicand;
 
                2'b11: temp_p <= p;
 
                default: temp_p <= p;
 
            endcase
            
            
            p <= temp_p;
            
            
            ctr <= ctr + 1'b1;
        end else begin
            
            rdy <= 1;
        end
    end
end

endmodule
