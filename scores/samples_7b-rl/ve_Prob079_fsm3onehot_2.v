
module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

assign out = (state == 4'b1000);

always @(*) begin
    case (state)
        4'b0001: begin 
            case (in)
                0: next_state = 4'b0001;
                1: next_state = 4'b0010;
            endcase
        end
        4'b0010: begin 
            case (in)
                0: next_state = 4'b0100;
                1: next_state = 4'b0010;
            endcase
        end
        4'b0100: begin 
            case (in)
                0: next_state = 4'b0001;
                1: next_state = 4'b1000;
            endcase
        end
        4'b1000: begin 
            case (in)
                0: next_state = 4'b0100;
                1: next_state = 4'b0010;
            endcase
        end
        default: next_state = 4'b0001;
    endcase
end

endmodule
