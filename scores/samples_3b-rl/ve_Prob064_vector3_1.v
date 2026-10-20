
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

    wire [49:0] all_inputs;
    wire [31:0] full_output;

    assign all_inputs = {a, b, c, d, e, f};
    assign full_output = {2'b00, all_inputs};

    assign w = full_output[31:24];
    assign x = full_output[23:16];
    assign y = full_output[15:8];
    assign z = full_output[7:0];

endmodule
