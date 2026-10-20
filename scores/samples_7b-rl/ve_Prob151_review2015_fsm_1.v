
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

    
    localparam IDLE       = 2'b00;
    localparam SHIFT      = 2'b01;
    localparam COUNTING   = 2'b10;
    localparam DONE_STATE = 2'b11;

    reg [1:0] current_state, next_state;
    reg [3:0] start_reg;
       
    reg [1:0] shift_cnt;
       
    reg [3:0] duration_reg;
    

    
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            start_reg <= 4'b0;
            shift_cnt <= 0;
            duration_reg <= 0;
        end else begin
            current_state <= next_state;
            
            
            if (current_state == IDLE)
                start_reg <= { start_reg[2:0], data };

            
            if (current_state == SHIFT) begin
                duration_reg <= { duration_reg[2:0], data };
                shift_cnt <= shift_cnt + 1;
            end
        end
    end

    
    always @(*) begin
        case (current_state)
            IDLE: 
                next_state = (start_reg == 4'b1101) ? SHIFT : IDLE;
            SHIFT: 
                next_state = (shift_cnt == 3) ? COUNTING : SHIFT;
            COUNTING: 
                next_state = done_counting ? DONE_STATE : COUNTING;
            DONE_STATE: 
                next_state = ack ? IDLE : DONE_STATE;
            default: 
                next_state = IDLE;
        endcase
    end

    
    assign shift_ena = (current_state == SHIFT);
    assign counting  = (current_state == COUNTING);
    assign done      = (current_state == DONE_STATE);

endmodule
