
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

    
    wire [29:0] concatenated;

    
    assign concatenated = {a, b, c, d, e, f};

    
    assign w = {2'b00, concatenated};
      
    assign x = {1'b0, concatenated};
       
    assign y = {2'b00, concatenated};
      
    assign z = {1'b0, concatenated};
       

endmodule
