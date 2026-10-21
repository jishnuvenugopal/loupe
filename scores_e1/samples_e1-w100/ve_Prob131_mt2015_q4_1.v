
module top_level (
    input wire x,
    input wire y,
    output reg z
);

    
    A u0 (
        .x(x),
        .y(y),
        .z(u0_z)
    );

    A u1 (
        .x(x),
        .y(y),
        .z(u1_z)
    );

    A u2 (
        .x(x),
        .y(y),
        .z(u2_z)
    );

    A u3 (
        .x(x),
        .y(y),
        .z(u3_z)
    );

    
    B u4 (
        .x(x),
        .y(y),
        .z(u4_z)
    );

    B u5 (
        .x(x),
        .y(y),
        .z(u5_z)
    );

    B u6 (
        .x(x),
        .y(y),
        .z(u6_z)
    );

    B u7 (
        .x(x),
        .y(y),
        .z(u7_z)
    );

    
    assign u4_y = u0_z;
    assign u5_y = u1_z;
    assign u6_y = u2_z;
    assign u7_y = u3_z;

    
    assign u0_x = u4_y;
    assign u1_x = u5_y;
    assign u2_x = u6_y;
    assign u3_x = u7_y;

    
    assign u0_or = u0_x | u0_y;
    assign u1_or = u1_x | u1_y;
    assign u2_or = u2_x | u2_y;
    assign u3_or = u3_x | u3_y;

    
    assign u0_and = u4_x & u4_y;
    assign u1_and = u5_x & u5_y;
    assign u2_and = u6_x & u6_y;
    assign u3_and = u7_x & u7_y;

    
    assign z = u0_or & u1_or & u2_or & u3_or & u0_and & u1_and & u2_and & u3_and;

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

    assign z = (x ^ y) & y;

endmodule
