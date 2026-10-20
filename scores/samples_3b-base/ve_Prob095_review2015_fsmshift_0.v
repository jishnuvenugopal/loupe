
module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    
    typedef enum {IDLE, SHIFT} state_t;
    state_t current_state, next_state;

    
    reg [3:0] counter;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            counter <= 4'b0000;
            shift_ena <= 1'b0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    if (counter == 4'b1111) begin
                        next_state <= SHIFT;
                        counter <= 4'b0000;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                SHIFT: begin
                    if (counter == 4'b1111) begin
                        next_state <= IDLE;
                        counter <= 4'b0000;
                    end else begin
                        next_state <= SHIFT;
                        counter <= counter + 1'b1;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk) begin
        if (current_state == SHIFT) begin
            shift_ena <= 1'b1;
        end else begin
            shift_ena <= 1'b0;
        end
    end

endmodule
