
module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    reg [3:0] shift_reg;
    reg [3:0] delay_reg;
    reg [1:0] state;
    reg [1:0] capture_counter;
    reg [9:0] step_counter;
    reg [4:0] count_reg;

    localparam STATE_IDLE = 2'b00;
    localparam STATE_CAPTURE = 2'b01;
    localparam STATE_COUNTING = 2'b10;
    localparam STATE_DONE = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_IDLE;
            shift_reg <= 4'b0;
            delay_reg <= 4'b0;
            capture_counter <= 2'b0;
            step_counter <= 10'b0;
            count_reg <= 5'b0;
            count <= 4'b0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= STATE_CAPTURE;
                        capture_counter <= 2'b0;
                    end
                end

                STATE_CAPTURE: begin
                    delay_reg <= {delay_reg[2:0], data};
                    if (capture_counter == 2'b11) begin
                        state <= STATE_COUNTING;
                        count_reg <= {1'b0, delay_reg} + 5'b1;
 
                        capture_counter <= 2'b0;
                        step_counter <= 10'b0;
                    end else begin
                        capture_counter <= capture_counter + 1;
                    end
                end

                STATE_COUNTING: begin
                    if (step_counter == 10'd999) begin
                        if (count_reg == 5'b0) begin
                            state <= STATE_DONE;
                        end else begin
                            count_reg <= count_reg - 1;
                            step_counter <= 10'b0;
                        end
                    end else begin
                        step_counter <= step_counter + 1;
                    end
                end

                STATE_DONE: begin
                    if (ack) begin
                        state <= STATE_IDLE;
                        shift_reg <= 4'b0;
                    end
                    count <= 4'b0;
 
                end

                default: state <= STATE_IDLE;
            endcase
        end
    end

    assign done = (state == STATE_DONE);
    assign counting = (state == STATE_COUNTING);
    assign count = (state == STATE_COUNTING) ? count_reg[3:0] : count;

endmodule
