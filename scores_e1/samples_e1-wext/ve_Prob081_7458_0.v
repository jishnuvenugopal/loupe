
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

    
    reg [2:0] and1a;
    reg [2:0] and1b;
    reg [2:0] and2a;
    reg [2:0] and2b;

    
    reg [1:0] or1;
    reg [1:0] or2;

    
    assign and1a = {p1a, p1b, p1c};
    assign and1b = {p1d, p1e, p1f};
    assign and2a = {p2a, p2b};
    assign and2b = {p2c, p2d};

    assign or1 = {and1a, and1b};
    assign or2 = {and2a, and2b};

    assign p1y = or1;
    assign p2y = or2;

endmodule
