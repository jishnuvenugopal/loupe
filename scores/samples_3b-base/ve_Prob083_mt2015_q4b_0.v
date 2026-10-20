
module TopModule (
    input  x,
    input  y,
    output z
);

    
    wire x_inv = ~x;
    wire y_inv = ~y;

    
    assign z = x_inv & y_inv;

endmodule
