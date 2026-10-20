
module TopModule (
    input  c,
    input  d,
    output reg [3:0] mux_in
);

    
    wire mux1_out;
    wire mux2_out;
    wire mux3_out;
    wire mux4_out;

    
    mux2_1 #(.WIDTH(1)) mux1 (
        .a(c),
        .b(d),
        .sel(1'b0),
        .out(mux1_out)
    );

    
    mux2_1 #(.WIDTH(1)) mux2 (
        .a(c),
        .b(d),
        .sel(1'b1),
        .out(mux2_out)
    );

    
    mux2_1 #(.WIDTH(1)) mux3 (
        .a(c),
        .b(d),
        .sel(1'b0),
        .out(mux3_out)
    );

    
    mux2_1 #(.WIDTH(1)) mux4 (
        .a(c),
        .b(d),
        .sel(1'b1),
        .out(mux4_out)
    );

    
    mux4_1 #(.WIDTH(4)) mux (
        .a(mux1_out),
        .b(mux2_out),
        .c(mux3_out),
        .d(mux4_out),
        .sel({c, d}),
        .out(mux_in)
    );

endmodule


module mux2_1 (
    input  a,
    input  b,
    input  sel,
    output reg out
);

    always @(a or b or sel) begin
        if (sel == 1'b0) out = a;
        else out = b;
    end

endmodule


module mux4_1 (
    input  a,
    input  b,
    input  c,
    input  d,
    input  sel,
    output reg out
);

    always @(a or b or c or d or sel) begin
        case (sel)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            2'b11: out = d;
            default: out = 1'b0;
 
        endcase
    end

endmodule
