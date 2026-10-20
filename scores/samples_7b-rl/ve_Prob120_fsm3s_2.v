
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);
    localparam [1:0] S_A = 0,
                     S_B = 1,
                     S_C = 2,
                     S_D = 3;

    reg [1:0] current_state, next_state;

    
    always @(posedge clk) begin
        if (reset)
            current_state <= S_A;
        else
            current_state <= next_state;
    end

    
    always @* begin
        case (current_state)
            S_A: next_state = in ? S_B : S_A;
            S_B: next_state = in ? S_B : S_C;
            S_C: next_state = in ? S_D : S_A;
            S_D: next_state = in ? S_B : S_C;
            default: next_state = S_A;
        endcase
    end

    
    assign out = (current_state == S_D);
endmodule
