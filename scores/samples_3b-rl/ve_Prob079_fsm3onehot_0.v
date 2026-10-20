
module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

always @(*) begin
    case (state)
        4'b0001: begin 
            if (in == 1'b0)
                next_state = 4'b0010;
            else
                next_state = 4'b0001;
            if (in == 1'b0)
                out = 1'b0;
            else
                out = 1'b0;
        end
        4'b0010: begin 
            if (in == 1'b0)
                next_state = 4'b0100;
            else
                next_state = 4'b0010;
            if (in == 1'b0)
                out = 1'b0;
            else
                out = 1'b0;
        end
        4'b0100: begin 
            if (in == 1'b0)
                next_state = 4'b0001;
            else
                next_state = 4'b1000;
            if (in == 1'b0)
                out = 1'b0;
            else
                out = 1'b1;
        end
        4'b1000: begin 
            if (in == 1'b0)
                next_state = 4'b0010;
            else
                next_state = 4'b0010;
            if (in == 1'b0)
                out = 1'b0;
            else
                out = 1'b1;
        end
    endcase
end

endmodule
