
module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        case (state)
            10'b0000000001: begin
                if (in == 1'b0)
                    next_state = 10'b0000000001;
                else
                    next_state = 10'b0000000010;
            end
            10'b0000000010: begin
                if (in == 1'b0)
                    next_state = 10'b0000000010;
                else
                    next_state = 10'b0000000100;
            end
            10'b0000000100: begin
                if (in == 1'b0)
                    next_state = 10'b0000000100;
                else
                    next_state = 10'b0000001000;
            end
            10'b0000001000: begin
                if (in == 1'b0)
                    next_state = 10'b0000001000;
                else
                    next_state = 10'b0000010000;
            end
            10'b0000010000: begin
                if (in == 1'b0)
                    next_state = 10'b0000010000;
                else
                    next_state = 10'b0000100000;
            end
            10'b0000100000: begin
                if (in == 1'b0)
                    next_state = 10'b0000100000;
                else
                    next_state = 10'b0001000000;
            end
            10'b0001000000: begin
                if (in == 1'b0)
                    next_state = 10'b0001000000;
                else
                    next_state = 10'b0010000000;
            end
            10'b0010000000: begin
                if (in == 1'b0)
                    next_state = 10'b0010000000;
                else
                    next_state = 10'b0100000000;
            end
            10'b0100000000: begin
                if (in == 1'b0)
                    next_state = 10'b0100000000;
                else
                    next_state = 10'b1000000000;
            end
            10'b1000000000: begin
                if (in == 1'b0)
                    next_state = 10'b1000000000;
                else
                    next_state = 10'b0000000001;
            end
            default: next_state = 10'b0000000001;
        endcase
    end

    always @(*) begin
        case (state)
            10'b0000000001: begin
                out1 = 1'b0;
                out2 = 1'b0;
            end
            10'b0000000010: begin
                out1 = 1'b0;
                out2 = 1'b0;
            end
            10'b0000000100: begin
                out1 = 1'b0;
                out2 = 1'b0;
            end
            10'b0000001000: begin
                out1 = 1'b0;
                out2 = 1'b0;
            end
            10'b0000010000: begin
                out1 = 1'b0;
                out2 = 1'b0;
            end
            10'b0000100000: begin
                out1 = 1'b0;
                out2 = 1'b0;
            end
            10'b0001000000: begin
                out1 = 1'b0;
                out2 = 1'b0;
            end
            10'b0010000000: begin
                out1 = 1'b0;
                out2 = 1'b0;
            end
            10'b0100000000: begin
                out1 = 1'b0;
                out2 = 1'b0;
            end
            10'b1000000000: begin
                out1 = 1'b0;
                out2 = 1'b0;
            end
            10'b1000000001: begin
                out1 = 1'b0;
                out2 = 1'b0;
            end
            default: begin
                out1 = 1'b0;
                out2 = 1'b0;
            end
        endcase
    end

endmodule
