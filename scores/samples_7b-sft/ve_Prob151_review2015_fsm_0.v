
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

    
    localparam IDLE         = 2'b00;
    localparam SHIFTING     = 2'b01;
    localparam WAIT_COUNTING= 2'b10;
    localparam DONE         = 2'b11;

    reg [1:0] current_state, next_state;
    reg [1:0] count;
 
    reg [3:0] shift_reg;
 

    
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 4'b0;
        else if (current_state == IDLE)
            shift_reg <= {shift_reg[2:0], data};
    end

    
    always @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    
    always @(*) begin
        case (current_state)
            IDLE: begin
                next_state = (shift_reg == 4'b1101) ? SHIFTING : IDLE;
            end
            SHIFTING: begin
                next_state = (count == 2'b11) ? WAIT_COUNTING : SHIFTING;
            end
            WAIT_COUNTING: begin
                next_state = done_counting ? DONE : WAIT_COUNTING;
            end
            DONE: begin
                next_state = ack ? IDLE : DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    
    always @(posedge clk) begin
        if (reset)
            count <= 2'b0;
        else if (current_state == SHIFTING) begin
            count <= (count < 2'b11) ? count + 1 : 2'b0;
        end else
            count <= 2'b0;
    end

    
    assign shift_ena = (current_state == SHIFTING);
    assign counting = (current_state == WAIT_COUNTING);
    assign done = (current_state == DONE);

endmodule
