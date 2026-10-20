
module TopModule (
    input  in,          
    output out          
);

    
    wire sign_bit = in[7];

    
    wire [23:0] sign_extension = {sign_bit, sign_bit, sign_bit, sign_bit, sign_bit, sign_bit, sign_bit, sign_bit,
                                  sign_bit, sign_bit, sign_bit, sign_bit, sign_bit, sign_bit, sign_bit, sign_bit,
                                  sign_bit, sign_bit, sign_bit, sign_bit, sign_bit, sign_bit, sign_bit, sign_bit};

    
    assign out = {sign_extension, in};

endmodule
