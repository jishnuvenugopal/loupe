
module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y,
    output p2y
);
    
    wire and_p1_part1, and_p1_part2, and_p2_part1, and_p2_part2;
    
    
    assign and_p1_part1 = p1a & p1b & p1c;
    assign and_p1_part2 = p1d & p1e & p1f;
    
    
    assign p1y = and_p1_part1 | and_p1_part2;
    
    
    assign and_p2_part1 = p2a & p2b;
    assign and_p2_part2 = p2c & p2d;
    
    
    assign p2y = and_p2_part1 | and_p2_part2;
endmodule
