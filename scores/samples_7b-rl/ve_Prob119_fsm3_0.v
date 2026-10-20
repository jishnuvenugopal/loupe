
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    
    localparam [1:0] S_A = 2'b00,
                     S_B = 2'b01,
                     S_C = 2'b10,
                     S_D = 2'b11;

    reg [1:0] state, next_state;

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S_A;
        else
            state <= next_state;
    end

    
    always @* begin
        case (state)
            S_A: next_state = in ? S_B : S_A;
            S_B: next_state = in ? S_B : S_C;
            S_C: next_state = in ? S_D : S_A;
            S_D: next_state = in ? S_B : S_C;
            default: next_state = S_A;
        endcase
    end

    
    assign out = (state == S_D);

endmodule
