
module TopModule (
    input  wire [7:0] in,
    output wire [31:0] out
);

    
    assign out = {in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0], in[7:0]};

endmodule
