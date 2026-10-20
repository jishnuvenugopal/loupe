
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    
    reg [3:0] shift_count;
    reg [3:0] shift_pattern;
    reg       start_pattern;
    reg       shift_ena_reg;
    reg       counting_reg;
    reg       done_reg;

    
    typedef enum {IDLE, SHIFT, COUNT, DONE} state_t;
    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                if (data == 4'b1101) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT: begin
                if (shift_count < 4) begin
                    next_state = SHIFT;
                end else begin
                    next_state = COUNT;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNT;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    
    always @(posedge clk) begin
        if (reset) begin
            shift_count   <= 4'b0;
            shift_pattern <= 4'b0;
            start_pattern <= 1'b0;
            shift_ena_reg <= 1'b0;
            counting_reg  <= 1'b0;
            done_reg      <= 1'b0;
        end else begin
            shift_count   <= (state == SHIFT) ? shift_count + 1'b1 : 4'b0;
            shift_pattern <= (state == SHIFT) ? {shift_pattern[2:0], data} : 4'b0;
            start_pattern <= (state == IDLE)  ? (data == 4'b1101) : 1'b0;
            shift_ena_reg <= (state == SHIFT) ? (shift_count < 4'b1000) : 1'b0;
            counting_reg  <= (state == COUNT) ? 1'b1 : 1'b0;
            done_reg      <= (state == DONE)  ? 1'b1 : 1'b0;
        end
    end

    
    assign shift_ena = shift_ena_reg;
    assign counting  = counting_reg;
    assign done      = done_reg;

endmodule
