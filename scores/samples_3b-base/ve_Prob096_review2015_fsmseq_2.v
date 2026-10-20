
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

    
    reg [3:0] last_four_bits;

    
    initial begin
        current_state = IDLE;
        start_shifting = 0;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == FOUND) begin
                
                start_shifting <= 1;
            end
        end
    end

    
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data == 1) begin
                    next_state = FIND_1;
                end else begin
                    next_state = IDLE;
                end
            end
            FIND_1: begin
                if (data == 1) begin
                    next_state = FIND_11;
                end else begin
                    next_state = IDLE;
                end
            end
            FIND_11: begin
                if (data == 0) begin
                    next_state = FIND_110;
                end else begin
                    next_state = IDLE;
                end
            end
            FIND_110: begin
                if (data == 1) begin
                    next_state = FIND_1101;
                end else begin
                    next_state = IDLE;
                end
            end
            FIND_1101: begin
                if (data == 1) begin
                    next_state = FOUND;
                end else begin
                    next_state = IDLE;
                end
            end
            FOUND: begin
                next_state = FOUND;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    
    always @(posedge clk) begin
        if (reset) begin
            last_four_bits <= 4'b0000;
        end else begin
            last_four_bits <= {last_four_bits[3:1], data};
        end
    end

endmodule
