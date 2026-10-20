
module TopModule (
    input  clk,
    input  in,
    output out
);
    reg flip_flop;

    always @(posedge clk) begin
        flip_flop <= in ^ out;
    end

    assign out = flip_flop;
endmodule
