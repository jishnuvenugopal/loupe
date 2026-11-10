
module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

    reg [1:0] memory;
 

    always @(posedge clk) begin
        if (a == 1'b1) begin
            memory <= b;
        end
        state <= memory;
        q <= state;
    end

endmodule
