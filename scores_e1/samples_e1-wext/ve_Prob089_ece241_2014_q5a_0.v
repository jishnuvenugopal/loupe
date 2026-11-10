
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg [7:0] state;
    reg [7:0] temp;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 8'b0;
            temp <= 8'b0;
            z <= 1'b0;
        end else begin
            case (state)
                8'b0: begin
                    if (x) begin
                        state <= 8'b1;
                        temp <= x;
                    end else begin
                        state <= 8'b0;
                        z <= 1'b0;
                    end
                end
                8'b1: begin
                    if (x) begin
                        state <= 8'b1;
                        temp <= x;
                    end else begin
                        state <= 8'b0;
                        z <= ~temp;
                    end
                end
            endcase
        end
    end

endmodule
