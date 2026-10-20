
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg out_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out_reg <= 1'b1;
        end else begin
            if (out_reg == 1'b1) begin
                if (in == 1'b0) begin
                    out_reg <= 1'b0;
                end
            end else begin
                if (in == 1'b0) begin
                    out_reg <= 1'b1;
                end
            end
        end
    end

    assign out = out_reg;

endmodule
