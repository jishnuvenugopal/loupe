
module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    
    typedef enum reg [1:0] {IDLE = 2'b00, DETECT = 2'b01, ENABLE = 2'b10, DONE = 2'b11} state_t;
    
    
    state_t current_state, next_state;
    reg [1:0] counter;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_ena <= 1;
            counter <= 2'b00;
        end else begin
            current_state <= next_state;
            if (current_state == ENABLE) begin
                if (counter < 2'b11) begin  
                    counter <= counter + 1;
                end else begin
                    shift_ena <= 0;
                end
            end else begin
                shift_ena <= 0;
            end
        end
    end

    
    always @(*) begin
        case (current_state)
            IDLE: if (reset) begin
                    next_state = DETECT;
                end else begin
                    next_state = IDLE;
                end
            DETECT: if () begin
                        next_state = ENABLE;
                    end else begin
                        next_state = DETECT;
                    end
            ENABLE: begin
                next_state = DONE;
            end
            DONE: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
