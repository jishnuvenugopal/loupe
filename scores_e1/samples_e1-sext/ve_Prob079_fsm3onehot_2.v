
module TopModule (
    input wire in,
    input wire [3:0] state,
    output reg next_state,
    output reg out
);


reg [3:0] current_state;


assign current_state = state;


always @(posedge in or negedge current_state) begin
    case (current_state)
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
            next_state = current_state;
            out = 1'b0;
        end
    endcase
end

endmodule
