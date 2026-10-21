
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
            carry <= 0;
            overflow <= 0;
        end else begin
            sum <= a + b + carry;
            carry <= sum[8];
            overflow <= (sum[7] ^ a[7] ^ b[7]) & carry;
        end
    end

    
    assign s = sum;
    assign overflow = overflow;

endmodule
