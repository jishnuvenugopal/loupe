
module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    
    typedef enum {S0, S1, S2} state_t;

    
    state_t state = S0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (state)
                S0: begin
                    if (x == 0) begin
                        state <= S1;
                    end else begin
                        state <= S2;
                    end
                end
                S1: begin
                    if (x == 0) begin
                        state <= S0;
                    end else begin
                        state <= S2;
                    end
                end
                S2: begin
                    if (x == 0) begin
                        state <= S0;
                    end else begin
                        state <= S1;
                    end
                end
            endcase
        end
    end

    
    assign z = (state == S0) && (x == 0);

endmodule
