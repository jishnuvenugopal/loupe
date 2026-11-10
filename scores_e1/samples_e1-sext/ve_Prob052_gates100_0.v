
module TopModule (
    input wire [99:0] in,
    output reg [1:0] out_and,
    output reg [1:0] out_or,
    output reg [1:0] out_xor
);

    
    assign out_and = in & in;

    
    assign out_or = in | in;

    
    assign out_xor = in ^ in;

endmodule
