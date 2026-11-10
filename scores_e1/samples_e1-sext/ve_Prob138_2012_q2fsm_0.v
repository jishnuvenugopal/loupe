
module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    reg [2:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            z <= 1'b0;
        end else begin
            case (state)
                3'b000: begin
                    if (w) begin
                        state <= 3'b001;
                    end else begin
                        state <= 3'b000;
                    end
                end
                3'b001: begin
                    state <= 3'b010;
                end
                3'b010: begin
                    if (w) begin
                        state <= 3'b011;
                    end else begin
                        state <= 3'b010;
                    end
                end
                3'b011: begin
                    state <= 3'b100;
                end
                3'b100: begin
                    if (w) begin
                        state <= 3'b101;
                    end else begin
                        state <= 3'b100;
                    end
                end
                3'b101: begin
                    state <= 3'b110;
                end
                3'b110: begin
                    if (w) begin
                        state <= 3'b111;
                    end else begin
                        state <= 3'b110;
                    end
                end
                3'b111: begin
                    state <= 3'b000;
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            3'b000: z <= 1'b0;
            3'b001: z <= 1'b1;
            3'b010: z <= 1'b0;
            3'b011: z <= 1'b1;
            3'b100: z <= 1'b0;
            3'b101: z <= 1'b1;
            3'b110: z <= 1'b0;
            3'b111: z <= 1'b1;
        endcase
    end

endmodule
