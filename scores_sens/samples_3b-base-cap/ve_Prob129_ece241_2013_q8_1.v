
module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    
    typedef enum { S0, S1, S2 } state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = S0;
    end

    
    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= S0;
            z <= 0;
        end else begin
            current_state <= next_state;
            case (current_state)
                S0: begin
                    if (x) begin
                        next_state = S1;
                    end else begin
                        next_state = S0;
                    end
                end
                S1: begin
                    if (x) begin
                        next_state = S2;
                    end else begin
                        next_state = S1;
                    end
                end
                S2: begin
                    if (x) begin
                        next_state = S0;
                    end else begin
                        next_state = S2;
                    end
                end
            endcase
        end
    end

    
    always_comb begin
        z = (current_state == S2);
    end

endmodule
