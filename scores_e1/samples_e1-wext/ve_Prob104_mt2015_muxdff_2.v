
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg [2:0] Q
);

    
    reg [2:0] flipflop;

    
    reg [2:0] multiplexer;

    
    assign flipflop = q_in;
    assign multiplexer = {flipflop[1] ^ flipflop[2], flipflop[0], flipflop[2]};
    assign Q = multiplexer;

endmodule

module main (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg [2:0] Q
);

    
    TopModule top_module1 (.clk(clk), .L(L), .q_in(q_in), .r_in(r_in), .Q(Q));
    TopModule top_module2 (.clk(clk), .L(L), .q_in(q_in), .r_in(r_in), .Q(Q));
    TopModule top_module3 (.clk(clk), .L(L), .q_in(q_in), .r_in(r_in), .Q(Q));

endmodule
