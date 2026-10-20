
module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    parameter [1:0] S0 = 2'b00,
                    S1 = 2'b01,
                    S2 = 2'b10;

    reg [1:0] current_state, next_state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    assign z = (current_state == S2) && x;

endmodule
