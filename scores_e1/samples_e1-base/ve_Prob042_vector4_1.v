
module TopModule (
    input  [7:0] in,  
    output [31:0] out  
);

    
    assign sign_bit = in[7];

    
    wire [23:0] replicated_sign_bit;
    genvar i;
    generate
        for (i = 0;
 i < 24;
 i = i + 1) begin
            assign replicated_sign_bit[i] = sign_bit;
        end
    endgenerate

    
    assign out = {replicated_sign_bit, in};

endmodule
