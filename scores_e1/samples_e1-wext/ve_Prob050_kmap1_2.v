
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    output reg out
);

    
    assign out = a ^ b ^ c;

endmodule
