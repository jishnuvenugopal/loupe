
module TopModule (
    input wire a,
    input wire b,
    input wire cin,
    output reg cout,
    output reg sum
);

    
    reg [2:0] sum_bits;
    reg [1:0] carry_out;

    
    always @(posedge cin or negedge a or negedge b) begin
        sum_bits = a ^ b ^ cin;
        carry_out = (a & b) | (a & cin) | (b & cin);
    end

    
    assign sum = sum_bits[1];
    assign cout = carry_out[1];

endmodule
