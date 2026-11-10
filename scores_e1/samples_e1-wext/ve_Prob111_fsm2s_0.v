
module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    
    reg [1:0] state;
    reg output;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            output <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    if (j == 1) begin
                        state <= 2'b01;
                        output <= 1'b1;
                    end else begin
                        state <= 2'b00;
                        output <= 1'b0;
                    end
                end
                2'b01: begin
                    if (k == 1) begin
                        state <= 2'b10;
                        output <= 1'b0;
                    end else begin
                        state <= 2'b01;
                        output <= 1'b1;
                    end
                end
                2'b10: begin
                    state <= 2'b00;
                    output <= 1'b0;
                end
                default: begin
                    state <= 2'b00;
                    output <= 1'b0;
                end
            endcase
        end
    end

endmodule
