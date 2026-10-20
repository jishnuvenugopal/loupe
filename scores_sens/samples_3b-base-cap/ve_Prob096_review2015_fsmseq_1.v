
module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    
    typedef enum {IDLE, FIND_1, FIND_0, FIND_1, FIND_1, SHIFTS} state_t;
    state_t current_state, next_state;

    
    reg [5:0] state_reg;

    
    reg [3:0] sequence_bits;

    
    reg current_bit;

    
    reg consecutive_ones;

    
    reg consecutive_zeros;

    
    reg [3:0] bits_processed;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            state_reg <= IDLE;
            sequence_bits <= 4'b0000;
            current_bit <= 1'b0;
            consecutive_ones <= 0;
            consecutive_zeros <= 0;
            bits_processed <= 0;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
            state_reg <= current_state;
            current_bit <= data;
            bits_processed <= bits_processed + 1'b1;

            
            case (current_state)
                IDLE: begin
                    if (current_bit == 1'b1) begin
                        sequence_bits <= 4'b0001;
                        next_state <= FIND_1;
                    end else begin
                        sequence_bits <= 4'b0000;
                        next_state <= IDLE;
                    end
                end
                FIND_1: begin
                    if (current_bit == 1'b0) begin
                        sequence_bits <= 4'b0010;
                        next_state <= FIND_0;
                    end else begin
                        sequence_bits <= 4'b0001;
                        next_state <= FIND_1;
                    end
                end
                FIND_0: begin
                    if (current_bit == 1'b1) begin
                        sequence_bits <= 4'b0101;
                        next_state <= FIND_1;
                    end else begin
                        sequence_bits <= 4'b0010;
                        next_state <= FIND_0;
                    end
                end
                FIND_1: begin
                    if (current_bit == 1'b1) begin
                        sequence_bits <= 4'b1101;
                        next_state <= SHIFTS;
                    end else begin
                        sequence_bits <= 4'b0101;
                        next_state <= FIND_1;
                    end
                end
                SHIFTS: begin
                    
                    next_state <= SHIFTS;
                end
            endcase

            
            if (sequence_bits == 4'b1101) begin
                start_shifting <= 1'b1;
            end
        end
    end

endmodule
