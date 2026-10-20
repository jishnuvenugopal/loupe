
module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    
    typedef enum { OFF, ON } state_t;
    state_t state, next_state;

    
    assign out = (state == ON) ? 1'b1 : 1'b0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= OFF;
 
        end else begin
            case (state)
                OFF: begin
                    if (j == 1'b1) begin
                        next_state <= ON;
 
                    end else begin
                        next_state <= OFF;
 
                    end
                end
                ON: begin
                    if (k == 1'b1) begin
                        next_state <= OFF;
 
                    end else begin
                        next_state <= ON;
 
                    end
                end
            endcase
            state <= next_state;
 
        end
    end

endmodule
