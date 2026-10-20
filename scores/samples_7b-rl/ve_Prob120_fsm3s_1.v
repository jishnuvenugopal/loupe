
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    C = 2'b10,
                    D = 2'b11;

    reg [1:0] current_state, next_state;

    
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? C : B;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    
    assign out = (current_state == D);

endmodule
