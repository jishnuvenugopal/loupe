
module TopModule(
    input [2:0] y,  
    input w,        
    output Y1       
);

reg [2:0] state, next_state;


always @(*) begin
    case (state)
        3'b000: next_state = y ? 3'b100 : 3'b001;
  
        3'b001: next_state = w ? 3'b100 : 3'b001;
  
        3'b010: next_state = y ? 3'b101 : 3'b011;
  
        3'b011: next_state = w ? 3'b100 : 3'b011;
  
        3'b100: next_state = y ? 3'b101 : 3'b011;
  
        3'b101: next_state = w ? 3'b010 : 3'b011;
  
        default: next_state = 3'b000;
    endcase
end


always @(posedge w) begin
    state <= next_state;
end


assign Y1 = state[1];

endmodule
