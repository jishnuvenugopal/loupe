
module TopModule (
    input wire in,
    input wire state,
    output reg next_state,
    output reg out
);


typedef enum {A, B, C, D} state_t;


always @(posedge in or posedge state) begin
    case (state)
        A: begin
            next_state = state;
            out = 0;
        end
        B: begin
            next_state = state;
            out = 0;
        end
        C: begin
            next_state = state;
            out = 0;
        end
        D: begin
            next_state = state;
            out = 1;
        end
        default: begin
            next_state = state;
            out = 0;
        end
    endcase
end

endmodule
