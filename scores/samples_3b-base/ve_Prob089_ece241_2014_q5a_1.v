
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

    
    initial begin
        current_state <= IDLE;
        accumulator <= 0;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= IDLE;
            accumulator <= 0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    if (x) begin
                        next_state <= ADD;
                    end else begin
                        next_state <= SUBTRACT;
                    end
                end
                ADD: begin
                    temp <= accumulator + x;
                    if (temp[31]) begin
                        accumulator <= temp - 2**32;
                    end else begin
                        accumulator <= temp;
                    end
                    next_state <= IDLE;
                end
                SUBTRACT: begin
                    temp <= accumulator - x;
                    if (temp[31]) begin
                        accumulator <= temp + 2**32;
                    end else begin
                        accumulator <= temp;
                    end
                    next_state <= IDLE;
                end
            endcase
        end
    end

    
    assign z = accumulator[31];

endmodule
