
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

    
    wire xor_result;

    
    wire and_result;

    
    xor_result <= x ^ y;

    
    and_result <= xor_result & x;

    
    z <= and_result;

endmodule
