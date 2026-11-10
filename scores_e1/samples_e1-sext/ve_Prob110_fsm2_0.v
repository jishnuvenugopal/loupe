
module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    
    reg [1:0] state;
    reg output;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            output <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    if (j == 1) begin
                        state <= 2'b01;
                    end else begin
                        state <= 2'b00;
                    end
                end
                2'b01: begin
                    if (k == 1) begin
                        state <= 2'b10;
                    end else begin
                        state <= 2'b01;
                    end
                end
                2'b10: begin
                    state <= 2'b00;
                end
                default: begin
                    state <= 2'b00;
                end
            endcase
        end
    end

    
    always @(*) begin
        case (state)
            2'b00: output <= 1'b0;
            2'b01: output <= 1'b1;
            2'b10: output <= 1'b0;
            default: output <= 1'b0;
        endcase
    end

endmodule
