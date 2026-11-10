
module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    
    typedef enum {OFF, ON} state_t;

    
    state_t state = OFF;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= OFF;
            out <= 0;
        end else begin
            case (state)
                OFF: begin
                    if (j == 0) begin
                        state <= OFF;
                        out <= 0;
                    end else if (j == 1) begin
                        state <= ON;
                        out <= 1;
                    end
                end
                ON: begin
                    if (k == 0) begin
                        state <= ON;
                        out <= 1;
                    end else if (k == 1) begin
                        state <= OFF;
                        out <= 0;
                    end
                end
            endcase
        end
    end

endmodule
