
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    
    typedef enum reg [1:0] {IDLE, SETUP, COMPUTE, DONE} state_t;
    state_t current_state, next_state;

    
    reg [31:0] sum;
    reg carry_in;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= IDLE;
            sum <= 0;
            carry_in <= 1;
 
        end else begin
            current_state <= next_state;
            if (current_state == SETUP) begin
                sum <= x;
                carry_in <= 0;
            end else if (current_state == COMPUTE) begin
                sum <= {carry_in, sum} + (x ? 32'b1 : 32'b0);
                carry_in <= carry_in & x;
            end
        end
    end

    
    always @(*) begin
        next_state = current_state;
        if (areset) begin
            next_state = IDLE;
        end else begin
            case (current_state)
                IDLE: if (!areset) next_state = SETUP;
                SETUP: next_state = COMPUTE;
                COMPUTE: if (areset) next_state = IDLE;
                DONE: if (areset) next_state = IDLE;
            endcase
        end
    end

    
    assign z = ~(sum ^ carry_in);

endmodule
