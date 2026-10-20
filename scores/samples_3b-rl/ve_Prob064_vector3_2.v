
module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    wire [29:0] concatenated;
    assign concatenated = {a, b, c, d, e, f};

    assign w = {2'b00, concatenated[29:16]};
    assign x = {2'b01, concatenated[29:16]};
    assign y = {2'b10, concatenated[29:16]};
    assign z = {2'b11, concatenated[29:16]};

endmodule
