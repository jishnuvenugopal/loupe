
module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output reg [7:0] w,
    output reg [7:0] x,
    output reg [7:0] y,
    output reg [7:0] z
);

    
    assign input_concat = {a, b, c, d, e, f};

    
    assign w = input_concat[7:0];
    assign x = input_concat[15:8];
    assign y = input_concat[23:16];
    assign z = input_concat[31:24];

    
    assign w[0] = 1'b1;
    assign w[1] = 1'b1;
    assign x[0] = 1'b1;
    assign x[1] = 1'b1;
    assign y[0] = 1'b1;
    assign y[1] = 1'b1;
    assign z[0] = 1'b1;
    assign z[1] = 1'b1;

endmodule
