
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;
    reg next_state;

    localparam B = 0;
    localparam A = 1;

    
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    
    always @* begin
        case (state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B;
        endcase
    end

    
    assign out = (state == B);

endmodule
