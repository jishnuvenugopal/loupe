
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

    
    reg [29:0] concatenated_input;

    always @(*) begin
        concatenated_input = a[4:0] << 24 | b[4:0] << 16 | c[4:0] << 8 | d[4:0] | e[4:0] | f[4:0];
    end

    
    assign w = concatenated_input[29:24];
    assign x = concatenated_input[23:18];
    assign y = concatenated_input[17:12];
    assign z = concatenated_input[11:6];

endmodule
