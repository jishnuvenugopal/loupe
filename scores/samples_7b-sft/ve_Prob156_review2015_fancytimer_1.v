
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);


localparam [1:0] IDLE = 2'b00;
localparam [1:0] CAPTURE_DELAY = 2'b01;
localparam [1:0] COUNTING = 2'b10;
localparam [1:0] DONE = 2'b11;

reg [1:0] state, next_state;


reg [3:0] start_shift;


reg [3:0] delay_shift;
reg [1:0] capture_counter;


reg [9:0] cycle_counter;
 
reg [3:0] delay_reg;
reg [3:0] step_counter;


always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shift <= 4'b0;
        delay_shift <= 4'b0;
        capture_counter <= 2'b0;
        cycle_counter <= 10'b0;
        step_counter <= 4'b0;
        delay_reg <= 4'b0;
    end else begin
        state <= next_state;

        if (state == CAPTURE_DELAY && next_state == COUNTING) begin
            delay_reg <= delay_shift;
            step_counter <= delay_shift + 1;
            cycle_counter <= 10'd0;
        end

        case (state)
            IDLE: begin
                start_shift <= {start_shift[2:0], data};
            end
            CAPTURE_DELAY: begin
                delay_shift <= {delay_shift[2:0], data};
                capture_counter <= capture_counter + 1;
            end
            COUNTING: begin
                if (cycle_counter == 10'd999) begin
                    cycle_counter <= 10'd0;
                    step_counter <= step_counter - 1;
                end else begin
                    cycle_counter <= cycle_counter + 1;
                end
            end
            DONE: begin
                if (ack) begin
                    delay_reg <= 4'b0;
                    start_shift <= 4'b0;
                end
            end
        endcase
    end
end


always @(*) begin
    case (state)
        IDLE: begin
            if (start_shift == 4'b1101)
                next_state = CAPTURE_DELAY;
            else
                next_state = IDLE;
        end
        CAPTURE_DELAY: begin
            if (capture_counter == 2'd3)
                next_state = COUNTING;
            else
                next_state = CAPTURE_DELAY;
        end
        COUNTING: begin
            if (step_counter == 4'b0)
                next_state = DONE;
            else
                next_state = COUNTING;
        end
        DONE: begin
            if (ack)
                next_state = IDLE;
            else
                next_state = DONE;
        end
        default: next_state = IDLE;
    endcase
end


always @(*) begin
    counting = (state == COUNTING);
    done = (state == DONE);
    count = (state == COUNTING) ? step_counter : 4'b0;
end

endmodule
