
module TopModule(
    input wire clk,
    input wire w,
    input wire R,
    input wire E,
    input wire L,
    output reg Q
);

reg shift_flag;

always @(posedge clk) begin
    if (L)
        shift_flag <= R;
    else if (E)
        shift_flag <= w;

    Q <= shift_flag;
end

endmodule
