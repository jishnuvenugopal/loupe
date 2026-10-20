
module TopModule (
    input  wire in,
    input  wire [9:0] state,
    output reg  [9:0] next_state,
    output wire       out1,
    output wire       out2
);

    always @(*) begin
        case (state)
            10'b0000000001: begin 
                next_state = 10'b0000000001;
                out1 = 1'b1;
                out2 = 1'b0;
            end
            10'b0000000010: begin 
                next_state = 10'b0000000010;
                out1 = 1'b1;
                out2 = 1'b0;
            end
            10'b0000000100: begin 
                next_state = 10'b0000000100;
                out1 = 1'b1;
                out2 = 1'b0;
            end
            10'b0000001000: begin 
                next_state = 10'b0000001000;
                out1 = 1'b1;
                out2 = 1'b0;
            end
            10'b0000010000: begin 
                next_state = 10'b0000010000;
                out1 = 1'b1;
                out2 = 1'b0;
            end
            10'b0000100000: begin 
                next_state = 10'b0000100000;
                out1 = 1'b1;
                out2 = 1'b0;
            end
            10'b0001000000: begin 
                next_state = 10'b0001000000;
                out1 = 1'b1;
                out2 = 1'b0;
            end
            10'b0010000000: begin 
                next_state = 10'b0010000000;
                out1 = 1'b0;
                out2 = 1'b1;
            end
            10'b0100000000: begin 
                next_state = 10'b0100000000;
                out1 = 1'b0;
                out2 = 1'b1;
            end
            default: begin
                next_state = state;
                out1 = 1'b0;
                out2 = 1'b0;
            end
        endcase
    end

endmodule
