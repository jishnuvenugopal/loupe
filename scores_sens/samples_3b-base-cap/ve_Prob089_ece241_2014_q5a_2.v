
module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    
    typedef enum {IDLE, ADD, SUBTRACT} state_t;
    state_t current_state, next_state;

    
    reg [7:0] accumulator;
    reg [7:0] temp;
    reg [7:0] carry;
    reg [7:0] result;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= IDLE;
            accumulator <= 8'b00000000;
            temp <= 8'b00000000;
            carry <= 8'b00000000;
            result <= 8'b00000000;
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
                    if (x) begin
                        temp <= accumulator + 1;
                        carry <= temp > 8'b11111111;
                        accumulator <= temp;
                        next_state <= ADD;
                    end else begin
                        temp <= accumulator - 1;
                        carry <= temp < 8'b00000000;
                        accumulator <= temp;
                        next_state <= SUBTRACT;
                    end
                end
                SUBTRACT: begin
                    if (x) begin
                        temp <= accumulator - 1;
                        carry <= temp < 8'b00000000;
                        accumulator <= temp;
                        next_state <= SUBTRACT;
                    end else begin
                        temp <= accumulator + 1;
                        carry <= temp > 8'b11111111;
                        accumulator <= temp;
                        next_state <= ADD;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk) begin
        if (current_state == ADD) begin
            z <= ~accumulator;
        end else if (current_state == SUBTRACT) begin
            z <= accumulator;
        end
    end

endmodule
