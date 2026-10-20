
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    reg [511:0] q_reg;
    assign q = q_reg;

    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load)
            q_reg <= data;
        else
            q_reg <= next_state;
    end

    always @* begin
        for (integer i = 0;
 i < 512;
 i = i + 1) begin
            next_state[i] = (i == 0 ? 1'b0 : q_reg[i-1]) ^ 
                            (i == 511 ? 1'b0 : q_reg[i+1]);
        end
    end

endmodule
