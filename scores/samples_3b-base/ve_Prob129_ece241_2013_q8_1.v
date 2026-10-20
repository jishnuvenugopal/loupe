
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

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            z <= 1'b0;
        end else begin
            case (current_state)
                S0: begin
                    if (x == 1'b1) begin
                        next_state = S1;
                    end else begin
                        next_state = S0;
                    end
                end
                S1: begin
                    if (x == 1'b0) begin
                        next_state = S2;
                    end else begin
                        next_state = S1;
                    end
                end
                S2: begin
                    if (x == 1'b1) begin
                        next_state = S0;
                    end else begin
                        next_state = S2;
                    end
                end
            endcase
            z <= (current_state == S2);
        end
    end

endmodule
