
module TopModule (
    input wire in,
    input wire [1:0] state,
    output reg next_state,
    output reg out
);

    
    always @(*) begin
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
        endcase
    end

endmodule
