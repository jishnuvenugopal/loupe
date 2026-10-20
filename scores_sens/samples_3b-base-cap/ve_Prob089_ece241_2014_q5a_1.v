
module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    
    typedef enum {IDLE, ADD, SUBTRACT} state_t;
    state_t current_state, next_state;

    
    reg [31:0] accumulator;
    reg [31:0] temp;
    reg [31:0] carry;
    reg [31:0] result;

    
    initial begin
        current_state = IDLE;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= IDLE;
            accumulator <= 0;
            temp <= 0;
            carry <= 0;
            result <= 0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    if (!x) begin
                        next_state <= ADD;
                    end else begin
                        next_state <= SUBTRACT;
                    end
                end
                ADD: begin
                    temp <= accumulator + x;
                    carry <= temp[32];
                    accumulator <= temp[31:0];
                    next_state <= IDLE;
                end
                SUBTRACT: begin
                    temp <= accumulator - x;
                    carry <= temp[32];
                    accumulator <= temp[31:0];
                    next_state <= IDLE;
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 0;
        end else begin
            z <= accumulator[31];
        end
    end

endmodule
