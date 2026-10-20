
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);

    
    reg [24:0] result;

    
    assign result[24] = ~a ^ a;
 
    assign result[23] = ~a ^ b;
 
    assign result[22] = ~a ^ c;
 
    assign result[21] = ~a ^ d;
 
    assign result[20] = ~a ^ e;
 
    assign result[19] = ~b ^ a;
 
    assign result[18] = ~b ^ b;
 
    assign result[17] = ~b ^ c;
 
    assign result[16] = ~b ^ d;
 
    assign result[15] = ~b ^ e;
 
    assign result[14] = ~c ^ a;
 
    assign result[13] = ~c ^ b;
 
    assign result[12] = ~c ^ c;
 
    assign result[11] = ~c ^ d;
 
    assign result[10] = ~c ^ e;
 
    assign result[ 9] = ~d ^ a;
 
    assign result[ 8] = ~d ^ b;
 
    assign result[ 7] = ~d ^ c;
 
    assign result[ 6] = ~d ^ d;
 
    assign result[ 5] = ~d ^ e;
 
    assign result[ 4] = ~e ^ a;
 
    assign result[ 3] = ~e ^ b;
 
    assign result[ 2] = ~e ^ c;
 
    assign result[ 1] = ~e ^ d;
 
    assign result[ 0] = ~e ^ e;
 

    
    assign out = result;

endmodule
