
module TopModule (
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

    
    always_comb begin
        case (state)
            2'b00: begin
                if (in == 1'b0) next_state = 2'b00;
 
                else next_state = 2'b01;
 
            end
            2'b01: begin
                if (in == 1'b0) next_state = 2'b01;
 
                else next_state = 2'b10;
 
            end
            2'b10: begin
                if (in == 1'b0) next_state = 2'b10;
 
                else next_state = 2'b00;
 
            end
            2'b11: begin
                if (in == 1'b0) next_state = 2'b11;
 
                else next_state = 2'b01;
 
            end
        endcase
    end

    
    always_comb begin
        case (state)
            2'b00: out = 1'b0;
 
            2'b01: out = 1'b0;
 
            2'b10: out = 1'b0;
 
            2'b11: out = 1'b1;
 
        endcase
    end

endmodule
