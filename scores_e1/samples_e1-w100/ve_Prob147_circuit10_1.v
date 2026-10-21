
module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    reg [1:0] flip_flop;

    always @(posedge clk) begin
        if (flip_flop == 2'b00) begin
            flip_flop <= {a, b};
        end else begin
            flip_flop <= flip_flop;
        end
        q <= flip_flop[0];
        state <= flip_flop[1];
    end

endmodule
