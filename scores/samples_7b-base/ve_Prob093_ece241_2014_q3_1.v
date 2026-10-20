
module TopModule(
    input c,
    input d,
    output reg [3:0] mux_in
);
reg sel_a, sel_b;


mux2to1 mux1(a=0, b=1, sel=c, out=sel_a);
mux2to1 mux2(a=0, b=1, sel=d, out=sel_b);


always @(*) begin
    case ({sel_b, sel_a})
        2'b00: mux_in = 4'b0001;
        2'b01: mux_in = 4'b0100;
        2'b11: mux_in = 4'b1111;
        2'b10: mux_in = 4'b0101;
    endcase
end
endmodule


module mux2to1(
    input a,
    input b,
    input sel,
    output reg out
);
always @(*) begin
    case (sel)
        0: out = a;
        1: out = b;
        default: out = 0;
 
    endcase
end
endmodule
