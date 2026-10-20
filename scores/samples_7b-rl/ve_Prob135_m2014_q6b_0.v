
module TopModule (input [2:0] y, input w, output Y1);
    assign Y1 = y[1];
    
    reg [2:0] next_state;
    always @* begin
        case(y)
            3'b000: next_state = w ? 3'b000 : 3'b001;
 
            3'b001: next_state = w ? 3'b011 : 3'b010;
 
            3'b010: next_state = w ? 3'b011 : 3'b100;
 
            3'b011: next_state = w ? 3'b000 : 3'b101;
 
            3'b100: next_state = w ? 3'b011 : 3'b100;
 
            3'b101: next_state = w ? 3'b011 : 3'b010;
 
            default: next_state = 3'b000;
 
        endcase
    end
endmodule
