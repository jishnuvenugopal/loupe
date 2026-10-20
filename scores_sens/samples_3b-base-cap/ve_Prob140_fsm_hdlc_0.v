
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    
    typedef enum logic [1:0] {
        IDLE,
        ONE,
        TWO,
        THREE,
        FOUR,
        FIVE,
        SIX,
        SEVEN,
        ERROR
    } state_t;

    
    state_t current_state = IDLE;

    
    reg [1:0] next_state;

    
    reg [4:0] count;

    
    reg prev_in;

    
    reg disc_reg;
    reg flag_reg;
    reg err_reg;

    
    always_comb begin
        case (current_state)
            IDLE: begin
                if (in == 1'b1) begin
                    next_state = ONE;
                    count = 1'b0;
                end else begin
                    next_state = IDLE;
                    count = 1'b0;
                end
            end
            ONE: begin
                if (in == 1'b1) begin
                    next_state = TWO;
                    count = count + 1'b1;
                end else begin
                    next_state = IDLE;
                    count = 1'b0;
                end
            end
            TWO: begin
                if (in == 1'b1) begin
                    next_state = THREE;
                    count = count + 1'b1;
                end else begin
                    next_state = IDLE;
                    count = 1'b0;
                end
            end
            THREE: begin
                if (in == 1'b1) begin
                    next_state = FOUR;
                    count = count + 1'b1;
                end else begin
                    next_state = IDLE;
                    count = 1'b0;
                end
            end
            FOUR: begin
                if (in == 1'b1) begin
                    next_state = FIVE;
                    count = count + 1'b1;
                end else begin
                    next_state = IDLE;
                    count = 1'b0;
                end
            end
            FIVE: begin
                if (in == 1'b1) begin
                    next_state = SIX;
                    count = count + 1'b1;
                end else begin
                    next_state = IDLE;
                    count = 1'b0;
                end
            end
            SIX: begin
                if (in == 1'b1) begin
                    next_state = SEVEN;
                    count = count + 1'b1;
                end else begin
                    next_state = IDLE;
                    count = 1'b0;
                end
            end
            SEVEN: begin
                if (in == 1'b1) begin
                    next_state = ERROR;
                    count = count + 1'b1;
                end else begin
                    next_state = IDLE;
                    count = 1'b0;
                end
            end
            ERROR: begin
                next_state = IDLE;
                count = 1'b0;
            end
        endcase
    end

    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
        end else begin
            current_state <= next_state;
            disc_reg <= (current_state == SEVEN);
            flag_reg <= (current_state == SIX);
            err_reg <= (current_state == ERROR);
        end
    end

    
    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule
