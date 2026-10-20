
module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    
    typedef enum {IDLE, LOAD, SHIFT} state_t;
    state_t current_state, next_state;

    
    reg Q_reg;

    
    initial begin
        current_state = IDLE;
    end

    
    always @(posedge clk) begin
        
        case (current_state)
            IDLE: begin
                if (E) begin
                    next_state = LOAD;
                end else if (L) begin
                    next_state = LOAD;
                end else begin
                    next_state = IDLE;
                end
            end
            LOAD: begin
                if (L) begin
                    next_state = LOAD;
                end else begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                if (E) begin
                    next_state = LOAD;
                end else if (L) begin
                    next_state = LOAD;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase

        
        current_state <= next_state;

        
        case (current_state)
            IDLE: begin
                Q_reg <= 0;
            end
            LOAD: begin
                Q_reg <= R;
            end
            SHIFT: begin
                Q_reg <= w;
            end
        endcase
    end

endmodule
