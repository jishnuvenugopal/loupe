
module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    
    typedef enum {IDLE, SHIFT} state_t;
    state_t current_state, next_state;

    
    
    reg [3:0] bit_pattern = 4'b1010;

    
    reg [3:0] detected_pattern = 4'b0000;

    
    reg [3:0] counter = 0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_ena <= 0;
            counter <= 0;
            detected_pattern <= 4'b0000;
        end else begin
            current_state <= next_state;

            
            if (current_state == IDLE) begin
                if (bit_pattern == detected_pattern) begin
                    next_state <= SHIFT;
                end else begin
                    next_state <= IDLE;
                end
            end else if (current_state == SHIFT) begin
                if (counter == 3) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= SHIFT;
                end
            end

            
            if (current_state == IDLE) begin
                if (bit_pattern == detected_pattern) begin
                    detected_pattern <= detected_pattern + 1'b1;
                end else begin
                    detected_pattern <= 4'b0000;
                end
            end

            
            if (current_state == IDLE || current_state == SHIFT) begin
                if (counter == 3) begin
                    counter <= 0;
                end else begin
                    counter <= counter + 1'b1;
                end
            end

            
            case (current_state)
                IDLE: shift_ena <= (counter == 3) ? 1'b1 : 0;
                SHIFT: shift_ena <= 1'b1;
            endcase
        end
    end

endmodule
