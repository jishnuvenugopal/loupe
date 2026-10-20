
module TopModule (
    input  [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    
    wire [29:0] concatenated_input;
    assign concatenated_input = {a, b, c, d, e, f};

    
    wire [7:0] w_output, x_output, y_output, z_output;
    assign w_output = concatenated_input[29:22];
    assign x_output = concatenated_input[21:14];
    assign y_output = concatenated_input[13:6];
    assign z_output = concatenated_input[5:0];

    
    assign w = {w_output, 2'b00};
    assign x = {x_output, 2'b00};
    assign y = {y_output, 2'b00};
    assign z = {z_output, 2'b00};

endmodule
