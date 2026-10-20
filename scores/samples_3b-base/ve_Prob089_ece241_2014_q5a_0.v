
module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    
    typedef enum {IDLE, PROCESSING, RESULT} state_t;
    state_t current_state, next_state;

    
    reg carry;
    reg [31:0] result;

    
    initial begin
        current_state = IDLE;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= IDLE;
            carry <= 0;
            result <= 0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    if (x) begin
                        next_state <= PROCESSING;
                        carry <= 1;
                    end else begin
                        next_state <= IDLE;
                        carry <= 0;
                    end
                end
                PROCESSING: begin
                    if (x) begin
                        next_state <= PROCESSING;
                        carry <= 1;
                    end else begin
                        next_state <= RESULT;
                        carry <= 0;
                    end
                end
                RESULT: begin
                    next_state <= IDLE;
                    result <= ~result + 1;
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 0;
        end else begin
            z <= result[31];
        end
    end

endmodule
