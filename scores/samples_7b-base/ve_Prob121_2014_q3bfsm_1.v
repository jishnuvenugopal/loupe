
module top_module (
    input clk,
    input reset,
    input x,
    output z
);

    
    typedef enum reg [2:0] {
        STATE_000,
        STATE_001,
        STATE_010,
        STATE_011,
        STATE_100
    } state_t;

    
    state_t state, next_state;

    
    reg z_reg;

    
    always @(*) begin
        case (state)
            STATE_000: begin
                if (x == 0) next_state = STATE_000;
                else if (x == 1) next_state = STATE_001;
            end
            STATE_001: begin
                if (x == 0) next_state = STATE_001;
                else if (x == 1) next_state = STATE_100;
            end
            STATE_010: begin
                if (x == 0) next_state = STATE_010;
                else if (x == 1) next_state = STATE_001;
            end
            STATE_011: begin
                if (x == 0) next_state = STATE_001;
                else if (x == 1) next_state = STATE_010;
            end
            STATE_100: begin
                if (x == 0) next_state = STATE_011;
                else if (x == 1) next_state = STATE_100;
            end
            default: next_state = STATE_000;
        endcase
    end

    
    always @(*) begin
        case (state)
            STATE_000, STATE_001, STATE_010: z_reg = 0;
            STATE_011, STATE_100: z_reg = 1;
            default: z_reg = 0;
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_000;
            z <= 0;
        end else begin
            state <= next_state;
            z <= z_reg;
        end
    end

endmodule
