
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    output reg out
);

    
    assign out = (a == 0) && (b == 1);

endmodule
