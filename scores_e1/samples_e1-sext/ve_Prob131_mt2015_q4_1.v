
module top_module (
    input wire x,
    input wire y,
    output reg z
);

    
    A uA1 (.x(x), .y(y), .z(z1));
    A uA2 (.x(x), .y(y), .z(z2));
    A uA3 (.x(x), .y(y), .z(z3));
    A uA4 (.x(x), .y(y), .z(z4));

    
    B uB1 (.x(x), .y(y), .z(z5));
    B uB2 (.x(x), .y(y), .z(z6));
    B uB3 (.x(x), .y(y), .z(z7));
    B uB4 (.x(x), .y(y), .z(z8));

    
    assign z1 = uA1.z | uA2.z;

    
    assign z2 = uA3.z & uA4.z;

    
    assign z = z1 ^ z2;

endmodule

module A (
    input wire x,
    input wire y,
    output reg z
);

    assign z = (x ^ y) & x;

endmodule

module B (
    input wire x,
    input wire y,
    output reg z
);

    assign z = (x ^ y) & x;

endmodule
