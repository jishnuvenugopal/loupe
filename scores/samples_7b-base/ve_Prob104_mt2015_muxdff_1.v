
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    reg q1, q2, q3;
    reg [2:0] r;

    assign r[0] = r_in;
    assign r[1] = r_in;
    assign r[2] = r_in;

    always @(posedge clk) begin
        if (L) begin
            q1 <= r;
            q2 <= r;
            q3 <= r;
        end else begin
            q1 <= {q1[1] ^ q1[2], q1[0], q1[2]};
            q2 <= {q2[1] ^ q2[2], q2[0], q2[2]};
            q3 <= {q3[1] ^ q3[2], q3[0], q3[2]};
        end
    end

    multiplexer m1 (q1[0], q2[0], q3[0], L, Q);
endmodule

module multiplexer (
    input a,
    input b,
    input c,
    input sel,
    output reg out
);
    always @(*) begin
        case (sel)
            0: out = a;
            1: out = b;
            2: out = c;
            default: out = 1'b0;
        endcase
    end
endmodule
