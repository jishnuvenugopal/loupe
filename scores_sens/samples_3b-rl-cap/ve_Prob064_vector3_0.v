
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

    wire [29:0] all_inputs;
    assign all_inputs = {a, b, c, d, e, f};

    assign w = {all_inputs, 2'b01};
    assign x = {all_inputs, 2'b10};
    assign y = {all_inputs, 2'b11};
    assign z = {all_inputs, 2'b11};

endmodule
