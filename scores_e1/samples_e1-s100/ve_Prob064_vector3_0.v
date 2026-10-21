
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

    
    wire [29:0] concatenated_input;

    assign concatenated_input = a | b | c | d | e | f;

    
    wire [7:0] w0, w1, w2, w3;
    assign w0 = concatenated_input[29:24];
    assign w1 = concatenated_input[23:18];
    assign w2 = concatenated_input[17:12];
    assign w3 = concatenated_input[11:6];

    
    wire [7:0] w4, w5, w6, w7;
    assign w4 = w0;
    assign w5 = w1;
    assign w6 = w2;
    assign w7 = w3;

    
    assign w = w4;
    assign x = w5;
    assign y = w6;
    assign z = w7;

endmodule
