
module HalfAdder (
    input wire a,
    input wire b,
    output reg sum,
    output reg cout
);

    
    assign sum = a ^ b;
    assign cout = a & b;

endmodule
