
module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    
    typedef enum {S0, S1, S2} state_t;

    
    state_t state = S0;

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 0;
        end else begin
            case (state)
                S0: begin
                    if (x == 1) begin
                        state <= S1;
                    end
                end
                S1: begin
                    if (x == 0) begin
                        state <= S2;
                    end
                end
                S2: begin
                    if (x == 1) begin
                        state <= S0;
                        z <= 1;
                    end
                end
            endcase
        end
    end

endmodule
