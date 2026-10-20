
module TopModule(input [4:0] a, b, c, d, e, f,
                output reg [7:0] w, x, y, z);

    
    wire [31:0] input_concat = {a, b, c, d, e, f, 1'b1, 1'b1};

    
    assign w = input_concat[7:0];
    assign x = input_concat[15:8];
    assign y = input_concat[23:16];
    assign z = input_concat[31:24];

endmodule
