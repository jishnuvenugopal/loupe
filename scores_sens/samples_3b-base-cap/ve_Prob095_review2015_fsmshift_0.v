
module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    
    typedef enum {IDLE, ENABLE, DONE} state_t;
    state_t current_state, next_state;

    
    reg [3:0] bit_pattern = 4'b1010;

    
    reg [3:0] counter;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            counter <= 4'b0;
            shift_ena <= 1'b0;
        end else begin
            current_state <= next_state;
            counter <= counter + 1'b1;
        end
    end

    
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (bit_pattern == 4'b1010) begin
                    next_state = ENABLE;
                end else begin
                    next_state = IDLE;
                end
            end
            ENABLE: begin
                if (counter == 4'b0111) begin
                    next_state = DONE;
                end else begin
                    next_state = ENABLE;
                end
            end
            DONE: begin
                next_state = IDLE;
            end
        endcase
    end

    
    always @(*) begin
        case (current_state)
            IDLE, ENABLE: shift_ena <= 1'b0;
            DONE: shift_ena <= 1'b1;
        endcase
    end

endmodule
