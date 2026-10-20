
module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    
    typedef enum { OFF, ON } State;
    State current_state, next_state;

    
    initial begin
        current_state = OFF;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            OFF: begin
                if (j == 0) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
            ON: begin
                if (k == 0) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
        endcase
    end

    
    assign out = current_state == ON;

endmodule
