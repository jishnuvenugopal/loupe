
module TopModule (
    input wire in1,
    input wire in2,
    input wire in3,
    output reg out
);

    
    assign xor1 = in1 ^ in2;

    
    assign out = xor1 ^ in3;

endmodule
