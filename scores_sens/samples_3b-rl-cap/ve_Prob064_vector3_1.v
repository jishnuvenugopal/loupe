
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
    wire [49:0] all_inputs_ext;

    assign all_inputs = {a, b, c, d, e, f};
    assign all_inputs_ext = {2'b00, all_inputs};

    assign w = all_inputs_ext[31:24];
    assign x = all_inputs_ext[23:16];
    assign y = all_inputs_ext[15:8];
    assign z = all_inputs_ext[7:0];

endmodule
