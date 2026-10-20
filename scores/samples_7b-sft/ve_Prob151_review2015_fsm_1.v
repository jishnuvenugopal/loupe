
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

    
    parameter IDLE = 2'b00;
    parameter SHIFTING = 2'b01;
    parameter COUNTING = 2'b10;
    parameter DONE = 2'b11;

    reg [1:0] current_state, next_state;
    reg [1:0] shift_counter;
 
    reg [3:0] shift_reg;
     

    
    always @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 4'b0;
        else if (current_state == IDLE)
            shift_reg <= {shift_reg[2:0], data};
    end

    
    always @(posedge clk) begin
        if (reset)
            shift_counter <= 2'b0;
        else if (current_state == SHIFTING)
            shift_counter <= shift_counter + 1'b1;
        else
            shift_counter <= 2'b0;
    end

    
    always @(*) begin
        case (current_state)
            IDLE: 
                next_state = (shift_reg == 4'b1101) ? SHIFTING : IDLE;
            SHIFTING: 
                next_state = (shift_counter == 2'b11) ? COUNTING : SHIFTING;
            COUNTING: 
                next_state = done_counting ? DONE : COUNTING;
            DONE: 
                next_state = ack ? IDLE : DONE;
            default: 
                next_state = IDLE;
        endcase
    end

    
    assign shift_ena = (current_state == SHIFTING);
    assign counting = (current_state == COUNTING);
    assign done = (current_state == DONE);

endmodule
