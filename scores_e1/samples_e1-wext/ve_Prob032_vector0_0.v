
module TopModule (
    input vec (3 bits) inVec,
    output outv (3 bits),
    output o2,
    output o1,
    output o0
);

    
    assign o0 = inVec[0];
    assign o1 = inVec[1];
    assign o2 = inVec[2];

endmodule
