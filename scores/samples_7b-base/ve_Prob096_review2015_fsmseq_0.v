
module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    
    typedef enum reg [2:0] {
        RESET,
        LOOKING_FOR_FIRST_1,
        LOOKING_FOR_SECOND_1,
        LOOKING_FOR_0,
        LOOKING_FOR_1,
        SEQUENCE_FOUND
    } state_t;

    state_t state, next_state;
    reg [2:0] shift_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= RESET;
        end else begin
            state <= next_state;
        end
    end

    
    always @(state or data) begin
        next_state = state;
        case (state)
            RESET: begin
                if (!reset) begin
                    next_state = LOOKING_FOR_FIRST_1;
                end
            end
            LOOKING_FOR_FIRST_1: begin
                shift_reg[0] <= data;
                if (data) begin
                    next_state = LOOKING_FOR_SECOND_1;
                end
            end
            LOOKING_FOR_SECOND_1: begin
                shift_reg[0] <= shift_reg[1];
                shift_reg[1] <= data;
                if (shift_reg[1]) begin
                    next_state = LOOKING_FOR_0;
                end
            end
            LOOKING_FOR_0: begin
                shift_reg[0] <= shift_reg[1];
                shift_reg[1] <= shift_reg[2];
                shift_reg[2] <= data;
                if (!shift_reg[2]) begin
                    next_state = LOOKING_FOR_1;
                end
            end
            LOOKING_FOR_1: begin
                shift_reg[0] <= shift_reg[1];
                shift_reg[1] <= shift_reg[2];
                shift_reg[2] <= shift_reg[3];
                shift_reg[3] <= data;
                if (shift_reg[3]) begin
                    next_state = SEQUENCE_FOUND;
                end
            end
            SEQUENCE_FOUND: begin
                
            end
        endcase
    end

    
    assign start_shifting = (state == SEQUENCE_FOUND);

endmodule
