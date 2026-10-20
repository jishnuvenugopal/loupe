
module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);


localparam S_IDLE         = 2'b00;
localparam S_SHIFT        = 2'b01;
localparam S_WAIT_COUNTING= 2'b10;
localparam S_DONE         = 2'b11;


reg [1:0] current_state, next_state;


reg [3:0] shift_reg;


reg [1:0] shift_counter;


reg shift_ena_reg;
reg counting_reg;
reg done_reg;


always @(posedge clk) begin
    if (reset)
        current_state <= S_IDLE;
    else
        current_state <= next_state;
end


always @* begin
    next_state = current_state;
    case (current_state)
        S_IDLE:
            if (shift_reg == 4'b1101)
                next_state = S_SHIFT;
        S_SHIFT:
            if (shift_counter == 2'd3)
                next_state = S_WAIT_COUNTING;
        S_WAIT_COUNTING:
            if (done_counting)
                next_state = S_DONE;
        S_DONE:
            if (ack)
                next_state = S_IDLE;
        default: next_state = S_IDLE;
    endcase
end


always @(posedge clk) begin
    if (reset)
        shift_reg <= 4'b0000;
    else
        shift_reg <= {shift_reg[2:0], data};
 
end


always @(posedge clk) begin
    if (reset)
        shift_counter <= 2'b0;
    else if (current_state == S_SHIFT) begin
        if (shift_counter == 2'd3)
            shift_counter <= 2'b0;
        else
            shift_counter <= shift_counter + 1;
    end else
        shift_counter <= 2'b0;
end


always @* begin
    shift_ena_reg = 0;
    counting_reg = 0;
    done_reg = 0;
    case (current_state)
        S_SHIFT: shift_ena_reg = 1;
        S_WAIT_COUNTING: counting_reg = 1;
        S_DONE: done_reg = 1;
    endcase
end


assign shift_ena = shift_ena_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule
