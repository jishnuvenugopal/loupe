
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;
    assign out = state ? in : ~in;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;
        end else begin
            state <= in;
        end
    end

endmodule
