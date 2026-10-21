
module TopModule (
    input wire in,
    input wire state,
    output reg next_state,
    output reg out
);

always @(posedge in or posedge state) begin
    case (state)
        2'b00: begin
            next_state = 2'b00;
            out = 1'b0;
        end
        2'b01: begin
            next_state = 2'b01;
            out = 1'b0;
        end
        2'b10: begin
            next_state = 2'b00;
            out = 1'b0;
        end
        2'b11: begin
            next_state = 2'b01;
            out = 1'b1;
        end
        default: begin
            next_state = state;
            out = 1'b0;
        end
    endcase
end

endmodule
