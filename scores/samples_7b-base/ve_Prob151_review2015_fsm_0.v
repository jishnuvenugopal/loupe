
module TopModule(
    input wire clk,
    input wire reset,
    input wire data,
    input wire done_counting,
    input wire ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    
    typedef enum reg [2:0] {
        IDLE, DETECT_1, DETECT_2, DETECT_3, DETECT_4, SHIFT, WAIT_COUNTING, DONE_WAIT_ACK, RESET
    } state_t;

    
    state_t current_state, next_state;

    
    reg [1:0] shift_reg;

    
    reg shift_ena_d, counting_d, done_d;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
            current_state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            
            current_state <= next_state;

            
            shift_ena <= shift_ena_d;
            counting <= counting_d;
            done <= done_d;
        end
    end

    
    always @(*) begin
        Shift_ena_d = 0;
        counting_d = 0;
        done_d = 0;

        case (current_state)
            IDLE: begin
                
                if (data == 1'b1) begin
                    next_state = DETECT_1;
                    shift_reg <= [data, 1'b0];
                end else begin
                    next_state = IDLE;
                end
            end

            DETECT_1: begin
                
                if (data == 1'b1) begin
                    next_state = DETECT_2;
                    shift_reg <= [data, shift_reg[0]];
                end else begin
                    next_state = IDLE;
                end
            end

            DETECT_2: begin
                
                if (data == 1'b0) begin
                    next_state = DETECT_3;
                    shift_reg <= [data, shift_reg[1:0]];
                end else begin
                    next_state = IDLE;
                end
            end

            DETECT_3: begin
                
                if (data == 1'b1) begin
                    next_state = DETECT_4;
                    shift_reg <= [data, shift_reg[2:0]];
                end else begin
                    next_state = IDLE;
                end
            end

            DETECT_4: begin
                
                shift_ena_d = 1;
                next_state = SHIFT;
            end

            SHIFT: begin
                
                shift_ena_d = 1;
                if (shift_reg == 4'b1101) begin
                    next_state = WAIT_COUNTING;
                end else begin
                    next_state = IDLE;
                end
            end

            WAIT_COUNTING: begin
                
                if (done_counting) begin
                    next_state = DONE_WAIT_ACK;
                end else begin
                    next_state = WAIT_COUNTING;
                end
            end

            DONE_WAIT_ACK: begin
                
                if (ack) begin
                    next_state = RESET;
                end else begin
                    next_state = DONE_WAIT_ACK;
                end
            end

            RESET: begin
                
                shift_ena_d = 0;
                counting_d = 0;
                done_d = 0;
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
