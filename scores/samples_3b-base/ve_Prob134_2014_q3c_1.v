
module TopModule (
    input  x,
    input  [2:0] y,
    output reg Y0,
    output reg z
);

    
    typedef enum {STATE_000, STATE_001, STATE_010, STATE_011, STATE_100} state_t;
    state_t current_state, next_state;

    
    reg [2:0] current_state_reg;

    
    always @(posedge x or posedge y) begin
        case (current_state)
            STATE_000: begin
                if (x == 0) next_state = y[2:0];
                else next_state = y[2:0];
            end
            STATE_001: begin
                if (x == 0) next_state = y[2:0];
                else next_state = y[2:0];
            end
            STATE_010: begin
                if (x == 0) next_state = y[2:0];
                else next_state = y[2:0];
            end
            STATE_011: begin
                if (x == 0) next_state = y[2:0];
                else next_state = y[2:0];
            end
            STATE_100: begin
                if (x == 0) next_state = y[2:0];
                else next_state = y[2:0];
            end
        endcase
    end

    
    always @(*) begin
        case (current_state)
            STATE_000: Y0 = y[0];
            STATE_001: Y0 = y[0];
            STATE_010: Y0 = y[0];
            STATE_011: Y0 = y[0];
            STATE_100: Y0 = y[0];
        endcase
    end

    
    always @(posedge x or posedge y) begin
        current_state_reg <= next_state;
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
