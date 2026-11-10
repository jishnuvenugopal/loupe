
module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    reg [7:0] sign_bit;
    reg [23:0] sign_extended;

    always @(*) begin
        
        sign_bit = in[7];

        
        sign_extended = sign_bit << 24;

        
        out = sign_extended | in;
    end

endmodule
