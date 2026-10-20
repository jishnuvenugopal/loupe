
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

    
    typedef enum {IDLE, START, COUNTING, DONE} state_t;
    state_t current_state, next_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data == 4'b1101) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;
                end
            end
            START: begin
                if (data == 4'b1101) begin
                    next_state = COUNTING;
                end else begin
                    next_state = IDLE;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNTING;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE;
                end
            end
        endcase
    end

    
    assign shift_ena = (current_state == START);
    assign counting = (current_state == COUNTING);
    assign done = (current_state == DONE);

endmodule
