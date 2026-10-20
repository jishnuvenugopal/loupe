
module full_module (
    input [2:0] r,
    input L,
    input clk,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (L) begin
        q <= r;
    end else begin
        q <= {q[1] ^ q[2], q[0], q[2]};
    end
end

endmodule

module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    wire [2:0] q0, q1, q2;
    wire [2:0] r0, r1, r2;

    
    full_module u0 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .q(q0)
    );
    full_module u1 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .q(q1)
    );
    full_module u2 (
        .clk(clk),
        .L(L),
        .q_in(q_in),
        .r_in(r_in),
        .q(q2)
    );

    
    assign r0 = 2'b00;
    assign r1 = 2'b01;
    assign r2 = 2'b10;

    
    wire [2:0] mux_out;
    assign mux_out = (r == r0) ? q0 :
                     (r == r1) ? q1 :
                     q2;

    
    assign Q = q0 | q1 | q2;

endmodule
