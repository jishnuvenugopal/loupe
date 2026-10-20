
module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    
    wire [2:0] q;
    wire mux_out [2:0];

    
    
    assign mux_out[2] = L ? r_in : (q[1] ^ q[2]);
    reg q2_reg;
    always @(posedge clk) q2_reg <= mux_out[2];

    
    assign mux_out[1] = L ? r_in : q[0];
    reg q1_reg;
    always @(posedge clk) q1_reg <= mux_out[1];

    
    assign mux_out[0] = L ? r_in : q[2];
    reg q0_reg;
    always @(posedge clk) q0_reg <= mux_out[0];

    assign q = {q2_reg, q1_reg, q0_reg};
    assign Q = q0_reg;

endmodule
