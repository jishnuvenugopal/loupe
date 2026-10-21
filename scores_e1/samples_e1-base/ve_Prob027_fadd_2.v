
module TopModule (
    input wire a,
    input wire b,
    input wire cin,
    output reg cout,
    output reg sum
);

    
    reg [2:0] adder_output;
    reg [1:0] carry_out;

    
    assign adder_output = a ^ b ^ cin;

    
    assign carry_out = (a & b) | (b & cin) | (a & cin);

    
    assign sum = adder_output;
    assign cout = carry_out;

endmodule
