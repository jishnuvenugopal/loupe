
module TopModule (
    input wire in,
    input wire [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);


typedef enum {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9} state_t;


always @(posedge in or posedge state) begin
    case (state)
        S0: begin
            next_state = state;
            out1 = 0;
            out2 = 0;
        end
        S1: begin
            next_state = state;
            out1 = 0;
            out2 = 0;
        end
        S2: begin
            next_state = state;
            out1 = 0;
            out2 = 0;
        end
        S3: begin
            next_state = state;
            out1 = 0;
            out2 = 0;
        end
        S4: begin
            next_state = state;
            out1 = 0;
            out2 = 0;
        end
        S5: begin
            next_state = state;
            out1 = 0;
            out2 = 0;
        end
        S6: begin
            next_state = state;
            out1 = 0;
            out2 = 0;
        end
        S7: begin
            next_state = state;
            out1 = 0;
            out2 = 0;
        end
        S8: begin
            next_state = state;
            out1 = 0;
            out2 = 0;
        end
        S9: begin
            next_state = state;
            out1 = 0;
            out2 = 0;
        end
        default: begin
            next_state = state;
            out1 = 0;
            out2 = 0;
        end
    endcase
end

endmodule
