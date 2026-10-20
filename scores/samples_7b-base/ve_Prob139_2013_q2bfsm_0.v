
module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    typedef enum reg [1:0] {
        STATE_A,
        STATE_B,
        STATE_C,
        STATE_D,
        STATE_E
    } state_t;

    state_t current_state, next_state;
    reg f_reg, g_reg;
    reg [1:0] x_counter;
    reg [1:0] y_counter;

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= STATE_A;
            f_reg <= 0;
            g_reg <= 0;
            x_counter <= 0;
            y_counter <= 0;
        end else begin
            current_state <= next_state;
            f <= f_reg;
            g <= g_reg;
            if (current_state == STATE_B) begin
                x_counter <= x_counter + 1;
            end else if (current_state == STATE_C) begin
                if (y == 1) begin
                    y_counter <= y_counter + 1;
                end else if (y_counter <= 2) begin
                    y_counter <= y_counter + 1;
                end else begin
                    g_reg <= 0;
                end
            end
        end
    end

    
    always @(*) begin
        next_state = current_state;
        f_reg = 0;
        g_reg = 0;
        case (current_state)
            STATE_A: begin
                if (resetn) begin
                    next_state = STATE_B;
                    f_reg = 1;
                end
            end
            STATE_B: begin
                if (x_counter == 2 && y_counter == 0) begin
                    next_state = STATE_C;
                end
            end
            STATE_C: begin
                if (y_counter >= 2) begin
                    next_state = STATE_D;
                end else if (y == 1) begin
                    y_counter = 1;
                    next_state = STATE_C;
                end
            end
            STATE_D: begin
                if (y == 1) begin
                    next_state = STATE_D;
                end else begin
                    next_state = STATE_E;
                end
            end
            STATE_E: begin
                
                next_state = STATE_A;
            end
        endcase
    end

endmodule
