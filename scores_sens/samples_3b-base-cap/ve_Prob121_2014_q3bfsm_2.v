
module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    
    typedef enum {STATE_000, STATE_001, STATE_010, STATE_011, STATE_100} state_t;

    
    state_t current_state, next_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= STATE_000;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            STATE_000: begin
                if (x == 0) begin
                    next_state = STATE_001;
                end else begin
                    next_state = STATE_000;
                end
            end
            STATE_001: begin
                if (x == 0) begin
                    next_state = STATE_001;
                end else begin
                    next_state = STATE_100;
                end
            end
            STATE_010: begin
                if (x == 0) begin
                    next_state = STATE_010;
                end else begin
                    next_state = STATE_001;
                end
            end
            STATE_011: begin
                if (x == 0) begin
                    next_state = STATE_001;
                end else begin
                    next_state = STATE_010;
                end
            end
            STATE_100: begin
                if (x == 0) begin
                    next_state = STATE_011;
                end else begin
                    next_state = STATE_100;
                end
            end
        endcase
    end

    
    always @(*) begin
        case (current_state)
            STATE_000: z = 0;
            STATE_001: z = 0;
            STATE_010: z = 0;
            STATE_011: z = 1;
            STATE_100: z = 1;
        endcase
    end

endmodule
