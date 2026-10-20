
module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output reg [15:0] y,
    output reg Co
);

    wire [7:0] a_low, a_high, b_low, b_high;
    wire [7:0] y_low, y_high;
    wire Co_low;

    
    assign a_low = a[7:0];
    assign a_high = a[15:8];
    assign b_low = b[7:0];
    assign b_high = b[15:8];

    
    adder_8bit adder_low (
        .a(a_low),
        .b(b_low),
        .cin(Cin),
        .y(y_low),
        .co(Co_low)
    );

    adder_8bit adder_high (
        .a(a_high),
        .b(b_high),
        .cin(Co_low),
        .y(y_high),
        .co(Co)
    );

endmodule

module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output reg [7:0] y,
    output reg co
);

    wire [8:0] temp;

    
    assign {co, y[0]} = a[0] + b[0] + cin;
    assign temp[1] = a[1] + b[1];
    assign {co, y[1]} = {temp[1][1], temp[1][0]} + y[0];
    assign temp[2] = a[2] + b[2];
    assign {co, y[2]} = {temp[2][1], temp[2][0]} + y[1];
    assign temp[3] = a[3] + b[3];
    assign {co, y[3]} = {temp[3][1], temp[3][0]} + y[2];
    assign temp[4] = a[4] + b[4];
    assign {co, y[4]} = {temp[4][1], temp[4][0]} + y[3];
    assign temp[5] = a[5] + b[5];
    assign {co, y[5]} = {temp[5][1], temp[5][0]} + y[4];
    assign temp[6] = a[6] + b[6];
    assign {co, y[6]} = {temp[6][1], temp[6][0]} + y[5];
    assign temp[7] = a[7] + b[7];
    assign {co, y[7]} = {temp[7][1], temp[7][0]} + y[6];

endmodule
