
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

reg first_1_found;
reg final_one;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        first_1_found <= 0;
        final_one <= 0;
        z <= 0;
    end else begin
        if (final_one) begin
            z <= 1;
            final_one <= 0;
        end else begin
            if (first_1_found) begin
                z <= ~x;
            end else begin
                if (x) begin
                    first_1_found <= 1;
                    z <= x;
                end else begin
                    z <= 0;
                end
            end
        end
    end
end

endmodule
