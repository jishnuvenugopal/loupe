
module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    
    typedef enum logic [3:0] {
        IDLE,
        FIND_1,
        FIND_11,
        FIND_110,
        FIND_1101,
        FOUND
    } state_t;

    
    state_t current_state, next_state;

    
    reg [3:0] current_state_reg;

    
    reg [3:0] last_four_bits;

    
    initial begin
        current_state_reg <= IDLE;
        start_shifting <= 0;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state_reg <= IDLE;
            start_shifting <= 0;
        end else begin
            current_state <= current_state_reg;
            next_state <= IDLE;

            case (current_state)
                IDLE: begin
                    if (data) begin
                        last_four_bits <= {last_four_bits[3:1], data};
                        next_state <= FIND_1;
                    end
                end
                FIND_1: begin
                    if (data) begin
                        last_four_bits <= {last_four_bits[3:1], data};
                        next_state <= FIND_11;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                FIND_11: begin
                    if (data) begin
                        last_four_bits <= {last_four_bits[3:1], data};
                        next_state <= FIND_110;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                FIND_110: begin
                    if (data) begin
                        last_four_bits <= {last_four_bits[3:1], data};
                        next_state <= FIND_1101;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                FIND_1101: begin
                    if (data) begin
                        last_four_bits <= {last_four_bits[3:1], data};
                        next_state <= FIND_1101;
                    end else begin
                        start_shifting <= 1;
                        next_state <= FOUND;
                    end
                end
                FOUND: begin
                    
                end
            endcase

            
            current_state_reg <= next_state;
        end
    end

endmodule
