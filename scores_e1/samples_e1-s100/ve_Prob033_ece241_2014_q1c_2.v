
module TopModule (
    input wire [7:0] a,  
    input wire [7:0] b,  
    output reg [7:0] s,  
    output reg overflow  
);

    
    reg [7:0] sum;
    reg [7:0] carry;

    always @(posedge clk or negedge rst) begin
        if (rst) begin
            sum <= 8'b0;
            carry <= 1'b0;
            overflow <= 1'b0;
        end else begin
            
            sum[7] <= a[7] + b[7] + carry;
            carry[7] <= sum[7] >> 1;

            
            overflow <= (sum[7] & ~a[7] & ~b[7]) | (~sum[7] & a[7] & b[7]);

            
            sum <= sum[6:0] + carry[6:0];
        end
    end

endmodule
