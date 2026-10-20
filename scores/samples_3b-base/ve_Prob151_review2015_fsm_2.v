
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
        SHIFT_ENA,
        COUNTING,
        DONE
    } state_t;

    
    state_t current_state, next_state;

    
    reg [3:0] shift_register;

    
    reg [3:0] counter;

    
    reg pattern_detected;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_register <= 4'b0000;
            counter <= 4'b0000;
            pattern_detected <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(current_state, data, done_counting, ack) begin
        case (current_state)
            IDLE: begin
                if (data == 4'b1101) begin
                    next_state <= WAIT_PATTERN;
                end else begin
                    next_state <= IDLE;
                end
            end
            WAIT_PATTERN: begin
                if (data == 4'b1101) begin
                    next_state <= SHIFT_ENA;
                end else begin
                    next_state <= IDLE;
                end
            end
            SHIFT_ENA: begin
                if (counter == 3'b111) begin
                    next_state <= COUNTING;
                end else begin
                    next_state <= SHIFT_ENA;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state <= DONE;
                end else begin
                    next_state <= COUNTING;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= DONE;
                end
            end
        endcase
    end

    
    assign shift_ena = (current_state == SHIFT_ENA);
    assign counting = (current_state == COUNTING);
    assign done = (current_state == DONE);

    
    always @(posedge clk) begin
        if (current_state == SHIFT_ENA) begin
            shift_register <= {shift_register[2:0], data};
        end
    end

    
    always @(posedge clk) begin
        if (current_state == COUNTING) begin
            counter <= counter + 1'b1;
        end
    end

endmodule
