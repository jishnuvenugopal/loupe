
module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);
    
    typedef enum reg [1:0] {OFF, ON} state_t;
    
    reg [1:0] currentState, nextState;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            currentState <= OFF;
        end else begin
            currentState <= nextState;
        end
    end
    
    always @(*) begin
        case (currentState)
            OFF: begin
                if (j) begin
                    nextState = ON;
                end else begin
                    nextState = OFF;
                end
            end
            ON: begin
                if (k) begin
                    nextState = OFF;
                end else begin
                    nextState = ON;
                end
            end
        endcase
    end
    
    assign out = (currentState == ON);
    
endmodule
