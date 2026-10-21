
module TopModule (
    input wire [99:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    
    reg [99:0] and_gate;
    reg [99:0] or_gate;
    reg [99:0] xor_gate;

    
    and_gate = in;
    or_gate = in;
    xor_gate = in;

    
    out_and = and_gate;
    out_or = or_gate;
    out_xor = xor_gate;

endmodule
