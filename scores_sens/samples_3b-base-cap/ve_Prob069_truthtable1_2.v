
module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

    
    

    
    wire not_x2 = ~x2;
    wire not_x1 = ~x1;

    
    wire and_x3_not_x2 = x3 & not_x2;
    wire and_x3_not_x1 = x3 & not_x1;
    wire and_x2_not_x1 = x2 & not_x1;

    
    wire or_result = and_x3_not_x2 | and_x3_not_x1 | and_x2_not_x1;

    
    assign f = or_result;

endmodule
