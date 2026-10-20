
module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    
    typedef enum {OFF, ON} State_t;
    State_t current_state, next_state;

    
    initial begin
        current_state = OFF;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= OFF;
 
        end else begin
            current_state <= next_state;
 
        end
    end

    
    always @(*) begin
        case (current_state)
            OFF: begin
                out = 1'b0;
 
                if (j == 1'b1) begin
                    next_state = ON;
 
                end else begin
                    next_state = OFF;
 
                end
            end
            ON: begin
                out = 1'b1;
 
                if (k == 1'b1) begin
                    next_state = OFF;
 
                end else begin
                    next_state = ON;
 
                end
            end
        endcase
    end

endmodule
