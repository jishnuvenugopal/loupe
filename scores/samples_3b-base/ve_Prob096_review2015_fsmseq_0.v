
module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
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

    
    reg [3:0] last_four_bits;

    
    initial begin
        current_state = IDLE;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            start_shifting <= 0;
            last_four_bits <= 0;
        end else begin
            
            case (current_state)
                IDLE: begin
                    if (data == 1'b1) begin
                        current_state <= FIND_1;
                    end else begin
                        current_state <= IDLE;
                    end
                end
                FIND_1: begin
                    if (data == 1'b1) begin
                        current_state <= FIND_11;
                    end else begin
                        current_state <= IDLE;
                    end
                end
                FIND_11: begin
                    if (data == 1'b0) begin
                        current_state <= FIND_110;
                    end else begin
                        current_state <= IDLE;
                    end
                end
                FIND_110: begin
                    if (data == 1'b1) begin
                        current_state <= FIND_1101;
                    end else begin
                        current_state <= IDLE;
                    end
                end
                FIND_1101: begin
                    if (data == 1'b1) begin
                        current_state <= FOUND;
                    end else begin
                        current_state <= IDLE;
                    end
                end
                FOUND: begin
                    start_shifting <= 1;
                end
            endcase

            
            last_four_bits <= {last_four_bits[0:2], data};
        end
    end

endmodule
