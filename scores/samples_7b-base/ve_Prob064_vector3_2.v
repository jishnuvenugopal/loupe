
module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output reg [7:0] w,
    output reg [7:0] x,
    output reg [7:0] y,
    output reg [7:0] z
);

    
    reg [29:0] concatenated_vector;
    assign concatenated_vector = {a, b, c, d, e, f};

    
    reg [31:0] extended_vector;
    assign extended_vector = {concatenated_vector, 2'b11};

    
    assign w = extended_vector[7:0];
    assign x = extended_vector[15:8];
    assign y = extended_vector[23:16];
    assign z = extended_vector[31:24];

endmodule
