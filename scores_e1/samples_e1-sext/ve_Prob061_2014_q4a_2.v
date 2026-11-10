
module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    reg [7:0] shift_register;

    always @(posedge clk) begin
        if (E) begin
            if (R) begin
                shift_register <= {Q, w};
            end else begin
                shift_register <= {w, Q};
            end
        end else begin
            if (L) begin
                Q <= shift_register[0];
            end
        end
    end

endmodule
