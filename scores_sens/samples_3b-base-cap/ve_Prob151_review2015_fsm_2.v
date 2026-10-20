
module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    
    typedef enum {
        IDLE,
        WAIT_PATTERN,
        SHIFT_DATA,
        COUNTING,
        NOTIFY_USER,
        WAIT_ACK
    } state_t;

    
    state_t current_state, next_state;

    
    reg [3:0] state_reg;

    
    reg [3:0] shift_reg;

    
    reg [3:0] counter;

    
    reg comparator_result;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= IDLE;
        end else begin
            state_reg <= next_state;
        end
    end

    
    always @(*) begin
        case (state_reg)
            IDLE: begin
                if (data == 4'b1101) begin
                    next_state = WAIT_PATTERN;
                end else begin
                    next_state = IDLE;
                end
            end
            WAIT_PATTERN: begin
                if (data == 4'b1101) begin
                    next_state = SHIFT_DATA;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT_DATA: begin
                if (counter == 3) begin
                    next_state = COUNTING;
                end else begin
                    next_state = SHIFT_DATA;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state = NOTIFY_USER;
                end else begin
                    next_state = COUNTING;
                end
            end
            NOTIFY_USER: begin
                next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_ACK;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    
    always @(*) begin
        case (state_reg)
            IDLE: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end
            WAIT_PATTERN: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end
            SHIFT_DATA: begin
                shift_ena = 1'b1;
                counting = 1'b0;
                done = 1'b0;
            end
            COUNTING: begin
                shift_ena = 1'b0;
                counting = 1'b1;
                done = 1'b0;
            end
            NOTIFY_USER: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b1;
            end
            WAIT_ACK: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end
            default: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end
        endcase
    end

    
    always @(posedge clk) begin
        if (state_reg == SHIFT_DATA) begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    
    always @(posedge clk) begin
        if (state_reg == COUNTING) begin
            counter <= counter + 1'b1;
        end
    end

    
    always @(*) begin
        comparator_result = (shift_reg == 4'b1101);
    end

endmodule
