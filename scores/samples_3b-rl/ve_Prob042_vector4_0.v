
module TopModule (
    input  wire [7:0] in,
    output wire [31:0] out
);

    
    assign out = {~in[7], 24'b0, in};

endmodule
