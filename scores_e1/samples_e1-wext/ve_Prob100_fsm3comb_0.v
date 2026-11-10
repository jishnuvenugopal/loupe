
module TopModule (
    input wire in,
    input wire state,
    output reg next_state,
    output reg out
);

    
    parameter A = 2'b00,
             B = 2'b01,
             C = 2'b10,
             D = 2'b11;

    
    always @(state or in) begin
        case (state)
            A: begin
                next_state = A;
                out = 0;
            end
            B: begin
                next_state = C;
                out = 0;
            end
            C: begin
                next_state = A;
                out = 0;
            end
            D: begin
                next_state = C;
                out = 1;
            end
            default: begin
                next_state = state;
                out = 0;
            end
        endcase
    end

endmodule
