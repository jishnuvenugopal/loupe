
module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);


parameter IDLE = 3'b000;
parameter DETECT_PATTERN = 3'b001;
parameter SHIFT_DATA = 3'b010;
parameter WAIT_COUNTING = 3'b011;
parameter TIMER_DONE = 3'b100;


reg [2:0] current_state, next_state;


reg [3:0] detected_bits;
reg shift_ena_reg;
reg counting_reg;
reg done_reg;


always @(posedge clk or posedge reset) begin
    if (reset)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

always @(*) begin
    next_state = current_state;
    shift_ena_reg = 0;
    counting_reg = 0;
    done_reg = 0;

    case (current_state)
        IDLE: begin
            if (data == 1'b1 && detected_bits == 4'b110) begin
                shift_ena_reg = 1;
                detected_bits <= {data, detected_bits[3:1]};
                next_state = SHIFT_DATA;
            end else begin
                detected_bits <= {data, detected_bits[3:1]};
            end
        end

        SHIFT_DATA: begin
            if (shift_ena_reg) begin
                shift_ena_reg = 0;
                detected_bits <= {data, detected_bits[3:1]};
                if (shift_count == 3) begin
                    shift_ena_reg = 0;
                    detected_bits <= {data, detected_bits[3:1]};
                    next_state = WAIT_COUNTING;
                end
            end
        end

        WAIT_COUNTING: begin
            if (done_counting) begin
                next_state = TIMER_DONE;
            end
        end

        TIMER_DONE: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end


assign shift_ena = shift_ena_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule
