
module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    
    reg [1:0] state;
    reg output;

    
    initial begin
        state = 2'b00;
        out = 0;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            out <= 0;
        end else begin
            case (state)
                2'b00: begin
                    if (j == 1) begin
                        state <= 2'b01;
                        out <= 1;
                    end else begin
                        state <= 2'b00;
                        out <= 0;
                    end
                end
                2'b01: begin
                    if (k == 1) begin
                        state <= 2'b10;
                        out <= 1;
                    end else begin
                        state <= 2'b01;
                        out <= 0;
                    end
                end
                2'b10: begin
                    state <= 2'b00;
                    out <= 0;
                end
            endcase
        end
    end

endmodule
