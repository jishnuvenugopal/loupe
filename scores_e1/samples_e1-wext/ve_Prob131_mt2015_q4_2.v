
module top (
    input wire x,
    input wire y,
    output reg z
);

    
    module A (
        input wire x,
        input wire y,
        output reg z
    );
        assign z = (x^y) & x;
    endmodule

    
    module B (
        input wire x,
        input wire y,
        output reg z
    );
        assign z = (x^y) & x;
    endmodule

    
    A u0 (
        .x(x),
        .y(y),
        .z(z)
    );

    A u1 (
        .x(x),
        .y(y),
        .z(z)
    );

    A u2 (
        .x(x),
        .y(y),
        .z(z)
    );

    A u3 (
        .x(x),
        .y(y),
        .z(z)
    );

    
    B u4 (
        .x(x),
        .y(y),
        .z(z)
    );

    B u5 (
        .x(x),
        .y(y),
        .z(z)
    );

    B u6 (
        .x(x),
        .y(y),
        .z(z)
    );

    B u7 (
        .x(x),
        .y(y),
        .z(z)
    );

    
    assign z = u0.z | u1.z & u2.z | u3.z & u4.z | u5.z & u6.z | u7.z;

endmodule
