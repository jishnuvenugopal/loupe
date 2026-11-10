
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

    
    assign w = input_concat[29:24];
    assign x = input_concat[23:18];
    assign y = input_concat[17:12];
    assign z = input_concat[11:6];

endmodule
