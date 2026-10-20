
module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    
    typedef enum logic [1:0] {
        OFF,
        ON
    } state_t;

    
    state_t current_state, next_state;

    
    assign out = current_state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            
            current_state <= OFF;
        end else begin
            
            case (current_state)
                OFF: begin
                    if (j == 1) begin
                        next_state <= ON;
                    end else begin
                        next_state <= OFF;
                    end
                end
                ON: begin
                    if (k == 1) begin
                        next_state <= OFF;
                    end else begin
                        next_state <= ON;
                    end
                end
            endcase

            
            current_state <= next_state;
        end
    end

endmodule
