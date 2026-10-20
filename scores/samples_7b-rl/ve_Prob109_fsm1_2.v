
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    localparam B = 1;
    localparam A = 0;
    reg state;

    
    reg next_state;

    
    always @ (posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    
    always @ (*) begin
        case (state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B;
        endcase
    end

    
    assign out = state;

endmodule
