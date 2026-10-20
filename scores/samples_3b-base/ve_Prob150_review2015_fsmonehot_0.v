
module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output reg done,
    output reg counting,
    output reg shift_ena
);

    
    always @(*) begin
        case (state)
            10'b0000000001: begin
                if (d == 0) S_next = 10'b0000000001;
                else S1_next = 10'b0000000010;
            end
            10'b0000000010: begin
                if (d == 0) S_next = 10'b0000000010;
                else S11_next = 10'b0000000100;
            end
            10'b0000000100: begin
                if (d == 0) S_next = 10'b0000000100;
                else S110_next = 10'b0000000101;
            end
            10'b0000000101: begin
                if (d == 0) S_next = 10'b0000000101;
                else B0_next = 10'b0000000110;
            end
            10'b0000000110: begin
                if (shift_ena == 1) B1_next = 10'b0000000111;
                else B1_next = state;
            end
            10'b0000000111: begin
                if (shift_ena == 1) B2_next = 10'b0000001000;
                else B2_next = state;
            end
            10'b0000001000: begin
                if (shift_ena == 1) B3_next = 10'b0000001001;
                else B3_next = state;
            end
            10'b0000001001: begin
                if (shift_ena == 1) Count_next = 10'b0000001010;
                else Count_next = state;
            end
            10'b0000001010: begin
                if (counting == 1 && done_counting == 0) Count_next = 10'b0000001010;
                else Count_next = state;
            end
            10'b0000001011: begin
                if (counting == 1 && done_counting == 1) Wait_next = 10'b0000001011;
                else Wait_next = state;
            end
            10'b0000001100: begin
                if (done == 1 && ack == 0) Wait_next = 10'b0000001100;
                else Wait_next = state;
            end
            10'b0000001101: begin
                if (done == 1 && ack == 1) S_next = 10'b0000001101;
                else S_next = state;
            end
            default: begin
                S_next = state;
            end
        endcase
    end

    
    always @(*) begin
        done = done_counting;
        counting = shift_ena;
        shift_ena = d;
    end

endmodule
