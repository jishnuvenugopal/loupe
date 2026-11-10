
module TopModule (
    input vec (3 bits) input_vector,
    output outv (3 bits),
    output o2,
    output o1,
    output o0
);

    
    assign o0 = input_vector[0];
    assign o1 = input_vector[1];
    assign o2 = input_vector[2];

endmodule
