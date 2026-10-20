
module TopModule (
    input  wire in,
    input  wire [9:0] state,
    output reg  [9:0] next_state,
    output reg        out1,
    output reg        out2
);

always @(*) begin
    case (state)
        10'b0000000001: begin
            next_state = 10'b0000000000;
            if (in)
                out1 = 1'b1;
            else
                out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b0000000010: begin
            next_state = 10'b0000000001;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b0000000100: begin
            next_state = 10'b0000000000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b0000001000: begin
            next_state = 10'b0000000100;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b0000010000: begin
            next_state = 10'b0000000000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b0000100000: begin
            next_state = 10'b0000001000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b0001000000: begin
            next_state = 10'b0000010000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b0010000000: begin
            next_state = 10'b0000000000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b0100000000: begin
            next_state = 10'b0000010000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b1000000000: begin
            next_state = 10'b0000100000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b1100000000: begin
            next_state = 10'b0000100000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b1110000000: begin
            next_state = 10'b0000100000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b1111000000: begin
            next_state = 10'b0000100000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b1111100000: begin
            next_state = 10'b0000100000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b1111110000: begin
            next_state = 10'b0000100000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b1111111000: begin
            next_state = 10'b0000100000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b1111111100: begin
            next_state = 10'b0000100000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b1111111110: begin
            next_state = 10'b0000100000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b1111111111: begin
            next_state = 10'b0000100000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b0000000007: begin
            next_state = 10'b0000000007;
            if (in)
                out1 = 1'b1;
            else
                out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b0000000008: begin
            next_state = 10'b0000000001;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        10'b0000000009: begin
            next_state = 10'b0000000001;
            out1 = 1'b0;
            out2 = 1'b0;
        end
        default: begin
            next_state = 10'b0000000000;
            out1 = 1'b0;
            out2 = 1'b0;
        end
    endcase
end

endmodule
