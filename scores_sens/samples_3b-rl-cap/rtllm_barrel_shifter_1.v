
module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);

    
    module mux2X1 (
        input [7:0] a,
        input [7:0] b,
        input sel,
        output reg [7:0] y
    );
        always @(*) begin
            if (sel)
                y = a;
            else
                y = b;
        end
    endmodule

    
    reg [7:0] shift1;
    mux2X1 m1 (
        .a(in),
        .b(8'b0),
        .sel(ctrl[2]),
        .y(shift1)
    );

    
    reg [7:0] shift2;
    mux2X1 m2 (
        .a(shift1),
        .b(8'b0),
        .sel(ctrl[1]),
        .y(shift2)
    );

    
    reg [7:0] shift3;
    mux2X1 m3 (
        .a(shift2),
        .b(8'b0),
        .sel(ctrl[0]),
        .y(shift3)
    );

    
    always @(*) begin
        if (ctrl[2])
            out = shift1;
        else if (ctrl[1])
            out = shift2;
        else if (ctrl[0])
            out = shift3;
        else
            out = in;
    end

endmodule
