
module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output reg [24:0] out
);

    assign out[24] = ~a ^ b;
    assign out[23] = ~a ^ c;
    assign out[22] = ~a ^ d;
    assign out[21] = ~a ^ e;
    assign out[20] = ~b ^ c;
    assign out[19] = ~b ^ d;
    assign out[18] = ~b ^ e;
    assign out[17] = ~c ^ d;
    assign out[16] = ~c ^ e;
    assign out[15] = ~d ^ e;

    
    assign out[14] = 0;
 
    assign out[13] = 0;
 
    assign out[12] = 0;
 
    assign out[11] = 0;
 
    assign out[10] = 0;
 
    assign out[ 9] = 0;
 
    assign out[ 8] = 0;
 
    assign out[ 7] = 0;
 
    assign out[ 6] = 0;
 
    assign out[ 5] = 0;
 
    assign out[ 4] = 0;
 
    assign out[ 3] = 0;
 
    assign out[ 2] = 0;
 
    assign out[ 1] = 0;
 
    assign out[ 0] = 0;
 

endmodule
