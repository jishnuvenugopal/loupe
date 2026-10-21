
module TopModule (
    input wire in1,
    input wire in2,
    input wire in3,
    output reg out
);

    
    wire xnor_out;

    
    wire xor_out;

    
    assign xnor_out = in1 ^ in2;

    
    assign xor_out = xnor_out ^ in3;

    
    assign out = xor_out;

endmodule
