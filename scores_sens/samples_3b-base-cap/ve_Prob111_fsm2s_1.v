
module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    
    typedef enum {OFF, ON} State;
    State current_state, next_state;

    
    initial begin
        current_state = OFF;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            OFF: begin
                out = 0;
                if (j) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                out = 1;
                if (k) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
        endcase
    end

endmodule
