
module TopModule (
    input wire [3:0] x,  
    input wire [3:0] y,  
    output reg [4:0] sum, 
    output reg overflow 
);


function reg full_adder(input reg a, input reg b, input reg cin);
    assign full_adder = a ^ b ^ cin;
endfunction


always @(*) begin
    reg [3:0] carry = 0;
    reg [4:0] sum = 0;

    for (int i = 0;
 i < 4;
 i++) begin
        sum[i] = full_adder(x[i], y[i], carry);
        carry = sum[i] >> 1;
    end

    
    overflow = carry;
end

endmodule
