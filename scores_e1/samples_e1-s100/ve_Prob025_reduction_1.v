
module TopModule (
    input  [7:0] in,  
    output [8:0] parity  
);

    
    reg [0:0] parity_bit;

    
    always @(in) begin
        parity_bit = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7];
    end

    
    assign parity = {in, parity_bit};

endmodule
