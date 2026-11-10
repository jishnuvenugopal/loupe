
module TopModule (
    input wire [3:0] x,
    input wire [3:0] y,
    output reg [4:0] sum
);

    
    always @(*) begin
        reg [3:0] carry;
        reg [3:0] sum_bits;

        
        sum_bits = x + y + carry;
        carry = sum_bits[4];

        
        if (sum_bits[4] == 1 && (x[3] == 1 && y[3] == 1)) begin
            sum_bits[4] = 1;
        end else begin
            sum_bits[4] = 0;
        end

        
        sum = sum_bits;
    end

endmodule
