
module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    
    typedef enum {A, B} StateType;
    StateType currentState, nextState;

    
    initial begin
        currentState = B;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            currentState <= B;
        end else begin
            currentState <= nextState;
        end
    end

    
    always @(*) begin
        case (currentState)
            A: begin
                if (in == 0) begin
                    nextState = B;
                end else begin
                    nextState = A;
                end
            end
            B: begin
                if (in == 1) begin
                    nextState = B;
                end else begin
                    nextState = A;
                end
            end
        endcase
        out = currentState == B;
    end

endmodule
