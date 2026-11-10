
module top (
    input wire x,
    input wire y,
    output reg z
);
    wire a1_z, a2_z, b1_z, b2_z;
    wire a1_or, a2_or, b1_and, b2_and;
    wire a1_xor, a2_xor;

    
    A a1 (
        .x(x),
        .y(y),
        .z(a1_z)
    );
    A a2 (
        .x(x),
        .y(y),
        .z(a2_z)
    );
    B b1 (
        .x(x),
        .y(y),
        .z(b1_z)
    );
    B b2 (
        .x(x),
        .y(y),
        .z(b2_z)
    );

    
    assign a1_or = a1_z | a2_z;
    assign a2_or = a1_z | a2_z;
    assign b1_and = a1_z & a2_z;
    assign b2_and = a1_z & a2_z;

    
    assign a1_xor = a1_z ^ a2_z;
    assign a2_xor = a1_z ^ a2_z;
    assign b1_xor = a1_z ^ a2_z;
    assign b2_xor = a1_z ^ a2_z;

    
    assign z = a1_or | a2_or & b1_and & b2_and;
endmodule
