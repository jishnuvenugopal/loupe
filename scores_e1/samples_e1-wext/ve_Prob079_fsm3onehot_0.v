
module TopModule (
    input wire in,
    input wire [3:0] state,
    output reg next_state,
    output reg out
);

    
    always @(in or state) begin
        case (state)
            4'b0001: next_state = in ? 4'b0010 : 4'b0100;
            4'b0010: next_state = in ? 4'b0100 : 4'b0001;
            4'b0100: next_state = in ? 4'b0001 : 4'b1000;
            4'b1000: next_state = in ? 4'b0100 : 4'b0001;
            default: next_state = state;
        endcase
    end

    
    assign out = 1'b0;

endmodule
