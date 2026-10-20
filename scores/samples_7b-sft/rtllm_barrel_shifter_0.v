
module mux2X1 (
    input a,
    input b,
    input sel,
    output out
);
    assign out = sel ? b : a;
endmodule

module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] stage1, stage2;

    generate
        genvar i, j, k;
        for (i = 0;
 i < 8;
 i = i + 1) begin : stage1
            wire a = in[i];
            wire b = (i >= 4) ? 1'b0 : in[i + 4];
            mux2X1 mux (
                .a(a),
                .b(b),
                .sel(ctrl[2]),
                .out(stage1[i])
            );
        end

        for (j = 0;
 j < 8;
 j = j + 1) begin : stage2
            wire a = stage1[j];
            wire b = (j >= 6) ? 1'b0 : stage1[j + 2];
            mux2X1 mux (
                .a(a),
                .b(b),
                .sel(ctrl[1]),
                .out(stage2[j])
            );
        end

        for (k = 0;
 k < 8;
 k = k + 1) begin : stage3
            wire a = stage2[k];
            wire b = (k >= 7) ? 1'b0 : stage2[k + 1];
            mux2X1 mux (
                .a(a),
                .b(b),
                .sel(ctrl[0]),
                .out(out[k])
            );
        end
    endgenerate
endmodule
