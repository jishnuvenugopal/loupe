
module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    
    reg [1:0] state;
    reg out;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            out <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    if (j == 1'b0) begin
                        state <= 2'b00;
                        out <= 1'b0;
                    end else begin
                        state <= 2'b01;
                        out <= 1'b1;
                    end
                end
                2'b01: begin
                    if (k == 1'b0) begin
                        state <= 2'b01;
                        out <= 1'b1;
                    end else begin
                        state <= 2'b10;
                        out <= 1'b0;
                    end
                end
                2'b10: begin
                    if (j == 1'b0) begin
                        state <= 2'b10;
                        out <= 1'b0;
                    end else begin
                        state <= 2'b11;
                        out <= 1'b1;
                    end
                end
                2'b11: begin
                    if (k == 1'b0) begin
                        state <= 2'b11;
                        out <= 1'b1;
                    end else begin
                        state <= 2'b00;
                        out <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule
