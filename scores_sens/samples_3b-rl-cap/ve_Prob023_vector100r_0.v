
module TopModule (
    input [99:0] in,
    output [99:0] out
);

    reg [99:0] reversed_in;

    always @(*) begin
        reversed_in = in;
        
        
        
        
        
        
        
        reversed_in = in[99:0] ^ 100'b1;
    end

    assign out = reversed_in;

endmodule
