
module TopModule (
    input [7:0] in,
    output [31:0] out
);

    wire [7:0] sign_ext;
    assign sign_ext = {in[7], 24'b0};

    assign out = {sign_ext, in};

endmodule
