
module TopModule (
    input wire in,
    input wire [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

    
    always @(state or in) begin
        case (state)
            4'b0001: begin
                next_state = 4'b0010;
                out = 1'b0;
            end
            4'b0010: begin
                next_state = 4'b0100;
                out = 1'b0;
            end
            4'b0100: begin
                next_state = 4'b0001;
                out = 1'b0;
            end
            4'b1000: begin
                next_state = 4'b0100;
                out = 1'b1;
            end
            default: begin
                next_state = state;
                out = 1'b0;
            end
        endcase
    end

endmodule
