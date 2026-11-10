
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] state;

    always @(posedge clk) begin
        if (load) begin
            state <= data;
        end else begin
            for (int i = 0;
 i < 512;
 i++) begin
                reg [1:0] left = (i == 0) ? 2'b00 : state[i-1];
                reg [1:0] right = (i == 511) ? 2'b00 : state[i+1];
                state[i] = left ^ right;
            end
        end
    end

    assign q = state;

endmodule
