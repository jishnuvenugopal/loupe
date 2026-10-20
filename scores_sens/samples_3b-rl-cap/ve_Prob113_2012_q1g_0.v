
module TopModule (
    input [3:0] x,
    output f
);

    
    
    
    
    wire [15:0] f_map;
    assign f_map = 16'b1000111111111111;

    
    assign f = f_map[{x[3], x[2], x[1], x[0]}];

endmodule
