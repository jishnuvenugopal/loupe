
module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);


typedef enum reg [2:0] {
    IDLE,
    ONE,
    TWO_1,
    THREE_1,
    FOUR_1,
    FIVE_1,
    SIX_1,
    SEVEN_1
} state_t;


state_t state, next_state;


reg disc_reg;
reg flag_reg;
reg err_reg;


assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
    end else begin
        state <= next_state;
        disc_reg <= disc_out;
        flag_reg <= flag_out;
        err_reg <= err_out;
    end
end


always @(*) begin
    next_state = state;
    disc_out = 1'b0;
    flag_out = 1'b0;
    err_out = 1'b0;

    case (state)
        IDLE:
            begin
                if (in == 1'b1)
                    next_state = ONE;
            end
        ONE:
            begin
                if (in == 1'b1)
                    next_state = TWO_1;
                else
                    next_state = IDLE;
            end
        TWO_1:
            begin
                if (in == 1'b1)
                    next_state = THREE_1;
                else
                    next_state = IDLE;
            end
        THREE_1:
            begin
                if (in == 1'b1)
                    next_state = FOUR_1;
                else
                    next_state = IDLE;
            end
        FOUR_1:
            begin
                if (in == 1'b1)
                    next_state = FIVE_1;
                else
                    next_state = IDLE;
            end
        FIVE_1:
            begin
                if (in == 1'b1)
                    next_state = SIX_1;
                else
                    next_state = IDLE;
            end
        SIX_1:
            begin
                if (in == 1'b0)
                    next_state = IDLE;
                else if (in == 1'b1)
                    next_state = SEVEN_1;
            end
        SEVEN_1:
            begin
                if (in == 1'b0)
                    next_state = flag;
                else
                    next_state = SEVEN_1;
            end
    endcase

    
    case (state)
        IDLE, ONE, TWO_1, THREE_1, FOUR_1, FIVE_1:
            disc_out = 1'b0;
        SIX_1:
            begin
                disc_out = 1'b1;
                flag_out = 1'b0;
                err_out = 1'b0;
            end
        SEVEN_1:
            begin
                disc_out = 1'b0;
                flag_out = 1'b0;
                err_out = 1'b1;
            end
    endcase

    
    if (state == SEVEN_1)
        next_state = flag;
end

endmodule
