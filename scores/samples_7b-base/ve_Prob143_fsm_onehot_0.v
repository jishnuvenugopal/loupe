
module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);


always @(*) begin
    case (state[9:0])
        10'b0000000001: begin 
            next_state = (in) ? 10'b0000000010 : 10'b0000000001;
            out1 = 0;
            out2 = 0;
        end
        10'b0000000010: begin 
            next_state = (in) ? 10'b0000000100 : 10'b0000000010;
            out1 = 0;
            out2 = 0;
        end
        10'b0000000100: begin 
            next_state = (in) ? 10'b0000001000 : 10'b0000000100;
            out1 = 0;
            out2 = 0;
        end
        10'b0000001000: begin 
            next_state = (in) ? 10'b0000010000 : 10'b0000001000;
            out1 = 0;
            out2 = 0;
        end
        10'b0000010000: begin 
            next_state = (in) ? 10'b0000100000 : 10'b0000010000;
            out1 = 0;
            out2 = 0;
        end
        10'b0000100000: begin 
            next_state = (in) ? 10'b0001000000 : 10'b0000100000;
            out1 = 0;
            out2 = 0;
        end
        10'b0001000000: begin 
            next_state = (in) ? 10'b0010000000 : 10'b0001000000;
            out1 = 1;
            out2 = 0;
        end
        10'b0010000000: begin 
            next_state = (in) ? 10'b0100000000 : 10'b0010000000;
            out1 = 1;
            out2 = 1;
        end
        default: begin
            next_state = 10'b0000000001;
            out1 = 0;
            out2 = 0;
        end
    endcase
end

endmodule
