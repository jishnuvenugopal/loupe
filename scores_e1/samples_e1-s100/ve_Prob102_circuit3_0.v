
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    
    wire and_gate_output;

    and_gate and_gate (
        .A(a),
        .B(b),
        .C(c),
        .D(d),
        .Y(and_gate_output)
    );

    
    always @(posedge clk) begin
        q <= and_gate_output;
    end

endmodule
