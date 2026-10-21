
module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    
    wire [29:0] input_vector;

    assign input_vector = {a, b, c, d, e, f};

    
    wire [7:0] w_out, x_out, y_out, z_out;

    assign w_out = input_vector[29:24];
    assign x_out = input_vector[23:18];
    assign y_out = input_vector[17:12];
    assign z_out = input_vector[11:6];

    
    assign w = {w_out, 1'b1};
    assign x = {x_out, 1'b1};
    assign y = {y_out, 1'b1};
    assign z = {z_out, 1'b1};

endmodule
