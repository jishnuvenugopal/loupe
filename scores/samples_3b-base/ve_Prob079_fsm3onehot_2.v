
module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    
    always @(*) begin
        case (state)
            4'b0001: begin
                if (in == 1'b0) next_state = 4'b0001;
 
                else next_state = 4'b0010;
 
            end
            4'b0010: begin
                if (in == 1'b0) next_state = 4'b0100;
 
                else next_state = 4'b0010;
 
            end
            4'b0100: begin
                if (in == 1'b0) next_state = 4'b0001;
 
                else next_state = 4'b1000;
 
            end
            4'b1000: begin
                if (in == 1'b0) next_state = 4'b0100;
 
                else next_state = 4'b0010;
 
            end
            default: next_state = 4'b0001;
 
        endcase
    end

    
    always @(*) begin
        case (state)
            4'b0001: out = 1'b0;
            4'b0010: out = 1'b0;
            4'b0100: out = 1'b0;
            4'b1000: out = 1'b1;
            default: out = 1'b0;
 
        endcase
    end

endmodule
