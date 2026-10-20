
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    wire [3:0] input_4bit;
    assign input_4bit = {a, b, c, d};

    
    assign out_sop = (input_4bit == 4'b0111) | (input_4bit == 4'b0010) | (input_4bit == 4'b1111);

    
    assign out_pos = 
        (input_4bit == 4'b0000) | (input_4bit == 4'b0001) | (input_4bit == 4'b0100) |
        (input_4bit == 4'b0101) | (input_4bit == 4'b0110) | (input_4bit == 4'b1001) |
        (input_4bit == 4'b1010) | (input_4bit == 4'b1011) | (input_4bit == 4'b1101) |
        (input_4bit == 4'b1110);

endmodule
