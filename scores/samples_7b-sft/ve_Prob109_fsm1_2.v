
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);
    localparam B = 1'b1;
    localparam A = 1'b0;
    
    reg state;
    reg next_state;
    
    
    always @(*) begin
        case (state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B;
        endcase
    end
    
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end
    
    
    assign out = state;
    
endmodule
