
module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg count[3:0],
    output reg counting,
    output reg done,
    input  ack
);

    
    typedef enum {IDLE, START, COUNTING, DONE} state_t;
    state_t current_state, next_state;

    
    reg [3:0] delay;
    reg [3:0] remaining_time;
    reg [3:0] shift_reg;
    reg [3:0] shift_reg_count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            count <= 4'b0;
            counting <= 0;
            done <= 0;
            delay <= 4'b0;
            remaining_time <= 4'b0;
            shift_reg <= 4'b0;
            shift_reg_count <= 0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        next_state <= START;
                    end else begin
                        next_state <= IDLE;
                    end
                end

                START: begin
                    shift_reg <= data;
                    shift_reg_count <= 4'b0;
                    next_state <= COUNTING;
                end

                COUNTING: begin
                    if (shift_reg_count == 4) begin
                        delay <= shift_reg;
                        remaining_time <= delay;
                        shift_reg_count <= 0;
                        next_state <= DONE;
                    end else begin
                        shift_reg_count <= shift_reg_count + 1;
                        shift_reg <= {shift_reg[3:0], data};
                    end
                end

                DONE: begin
                    if (remaining_time > 0) begin
                        count <= remaining_time;
                        remaining_time <= remaining_time - 1;
                        next_state <= DONE;
                    end else begin
                        done <= 1;
                        next_state <= IDLE;
                    end
                end
            endcase
        end
    end

    
    assign counting = (current_state == COUNTING);
    assign done = (current_state == DONE);

endmodule
