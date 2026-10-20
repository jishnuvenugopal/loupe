
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

    
    parameter S_IDLE      = 2'd0;
    parameter S_SHIFTING  = 2'd1;
    parameter S_COUNTING  = 2'd2;
    parameter S_DONE      = 2'd3;

    reg [1:0] state, next_state;
    reg [3:0] shift_reg;
    reg [1:0] shift_count;

    
    always @(posedge clk) begin
        if (reset)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 4'b0;
        else if (state == S_IDLE)
            shift_reg <= {shift_reg[2:0], data};
    end

    
    always @(posedge clk) begin
        if (reset)
            shift_count <= 0;
        else if (state == S_SHIFTING)
            shift_count <= shift_count + 1;
        else
            shift_count <= 0;
    end

    
    always @* begin
        next_state = state;
        case (state)
            S_IDLE: begin
                if (shift_reg == 4'b1101)
                    next_state = S_SHIFTING;
            end
            S_SHIFTING: begin
                if (shift_count == 3) 
                    next_state = S_COUNTING;
            end
            S_COUNTING: begin
                if (done_counting)
                    next_state = S_DONE;
            end
            S_DONE: begin
                if (ack)
                    next_state = S_IDLE;
            end
            default: next_state = S_IDLE;
        endcase
    end

    
    assign shift_ena = (state == S_SHIFTING);
    assign counting = (state == S_COUNTING);
    assign done = (state == S_DONE);

endmodule
