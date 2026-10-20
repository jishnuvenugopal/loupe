
module TopModule (
    input [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    wire [7:0] in_hi, in_lo;

    
    assign in_hi = in[15:8];
    assign in_lo = in[7:0];

    
    assign out_hi = in_hi;
    assign out_lo = in_lo;

endmodule
