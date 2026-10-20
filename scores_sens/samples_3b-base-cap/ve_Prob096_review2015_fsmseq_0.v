
module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    
    typedef enum logic [3:0] {
        IDLE,
        FIND_1,
        FIND_1_1,
        FIND_1_1_0,
        FIND_1_1_0_1,
        FOUND
    } state_t;

    
    state_t current_state, next_state;

    
    logic [3:0] shift_register;

    
    initial begin
        current_state = IDLE;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_register <= 4'b0000;
            start_shifting <= 1'b0;
        end else begin
            
            case (current_state)
                IDLE: begin
                    if (data == 1'b1) begin
                        next_state = FIND_1;
                    end else begin
                        next_state = IDLE;
                    end
                end
                FIND_1: begin
                    if (data == 1'b1) begin
                        next_state = FIND_1_1;
                    end else begin
                        next_state = IDLE;
                    end
                end
                FIND_1_1: begin
                    if (data == 1'b0) begin
                        next_state = FIND_1_1_0;
                    end else begin
                        next_state = IDLE;
                    end
                end
                FIND_1_1_0: begin
                    if (data == 1'b1) begin
                        next_state = FIND_1_1_0_1;
                    end else begin
                        next_state = IDLE;
                    end
                end
                FIND_1_1_0_1: begin
                    if (data == 1'b1) begin
                        next_state = FOUND;
                    end else begin
                        next_state = IDLE;
                    end
                end
                FOUND: begin
                    next_state = FOUND;
                end
            endcase

            
            if (current_state != FOUND) begin
                shift_register <= {shift_register[2:0], data};
            end

            
            if (current_state == FOUND) begin
                start_shifting <= 1'b1;
            end else begin
                start_shifting <= 1'b0;
            end

            
            current_state <= next_state;
        end
    end

endmodule
