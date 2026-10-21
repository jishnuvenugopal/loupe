
module TopModule (
    input vec (3 bits),
    output outv (3 bits),
    output o2,
    output o1,
    output o0
);

    
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule
