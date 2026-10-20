
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;
    reg z;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            case (state)
                1'b0: begin
                    if (x == 1'b0) begin
                        state <= 1'b0;
                        z <= 1'b0;
                    end else begin
                        state <= 1'b1;
                        z <= 1'b1;
                    end
                end
                1'b1: begin
                    if (x == 1'b0) begin
                        state <= 1'b1;
                        z <= 1'b1;
                    end else begin
                        state <= 1'b1;
                        z <= 1'b0;
                    end
                end
                default: begin
                    state <= 1'b0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule
