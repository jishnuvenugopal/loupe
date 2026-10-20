
module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    
    wire [2:0] AB = {A, B};

    
    
    
    

    
    
    

    
    A_greater = (AB[2] ^ AB[1]) & (AB[1] ^ AB[0]) & (AB[0] ^ AB[2]);
    A_equal = (AB[2] ^ AB[1]) & (AB[1] ^ AB[0]) & (AB[0] ^ AB[2]) & (AB[2] == AB[1] & AB[1] == AB[0]);
    A_less = (AB[2] ^ AB[1]) & (AB[1] ^ AB[0]) & (AB[0] ^ AB[2]) & (AB[2] != AB[1] | AB[1] != AB[0] | AB[0] != AB[2]);

endmodule
