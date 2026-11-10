
module TopModule (
    input wire p1a,
    input wire p1b,
    input wire p1c,
    input wire p1d,
    input wire p1e,
    input wire p1f,
    input wire p2a,
    input wire p2b,
    input wire p2c,
    input wire p2d,
    output reg p1y,
    output reg p2y
);

    
    wire and1a, and1b, and1c, and1d, and1e, and1f;
    wire and2a, and2b, and2c, and2d;

    
    wire or1a, or1b, or2a, or2b;

    
    assign and1a = p1a & p1b & p1c;
    assign and1b = p1d & p1e & p1f;
    assign and1c = p1a & p1b & p1c;
    assign and1d = p1d & p1e & p1f;
    assign and1e = p1a & p1b & p1c;
    assign and1f = p1d & p1e & p1f;

    assign and2a = p2a & p2b;
    assign and2b = p2c & p2d;

    
    assign or1a = and1a | and1b | and1c;
    assign or1b = and1d | and1e | and1f;
    assign or2a = and2a | and2b;

    
    assign p1y = or1a | or1b;
    assign p2y = or2a | or2b;

endmodule
