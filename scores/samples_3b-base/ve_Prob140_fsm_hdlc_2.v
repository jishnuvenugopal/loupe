
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    
    typedef enum {IDLE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, ERROR} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = IDLE;
    end

    
    reg [7:0] state_reg;

    
    reg [4:0] count;

    
    reg prev_in;

    
    reg disc_reg, flag_reg, err_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            state_reg <= 8'b0;
            count <= 5'b0;
            prev_in <= 1'b0;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
        end else begin
            
            prev_in <= in;

            
            if (in == 1'b1) begin
                count <= count + 1'b1;
            end else begin
                count <= 5'b0;
            end

            
            case (current_state)
                IDLE: begin
                    if (in == 1'b1) begin
                        next_state = ONE;
                    end else begin
                        next_state = IDLE;
                    end
                end
                ONE: begin
                    if (in == 1'b1) begin
                        next_state = TWO;
                    end else begin
                        next_state = IDLE;
                    end
                end
                TWO: begin
                    if (in == 1'b1) begin
                        next_state = THREE;
                    end else begin
                        next_state = IDLE;
                    end
                end
                THREE: begin
                    if (in == 1'b1) begin
                        next_state = FOUR;
                    end else begin
                        next_state = IDLE;
                    end
                end
                FOUR: begin
                    if (in == 1'b1) begin
                        next_state = FIVE;
                    end else begin
                        next_state = IDLE;
                    end
                end
                FIVE: begin
                    if (in == 1'b1) begin
                        next_state = SIX;
                    end else begin
                        next_state = IDLE;
                    end
                end
                SIX: begin
                    if (in == 1'b1) begin
                        next_state = SEVEN;
                    end else begin
                        next_state = IDLE;
                    end
                end
                SEVEN: begin
                    if (in == 1'b1) begin
                        next_state = ERROR;
                    end else begin
                        next_state = IDLE;
                    end
                end
                ERROR: begin
                    if (in == 1'b0) begin
                        next_state = IDLE;
                    end else begin
                        next_state = ERROR;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk) begin
        current_state <= next_state;
    end

    
    always @(posedge clk) begin
        disc_reg <= (current_state == SEVEN);
        flag_reg <= (current_state == SIX);
        err_reg <= (current_state == ERROR);
    end

    
    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule
