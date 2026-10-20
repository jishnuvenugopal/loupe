
module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);


parameter STATE_OFF = 1'b0;
parameter STATE_ON = 1'b1;


reg [0:0] current_state;


always @(current_state) begin
    case (current_state)
        STATE_OFF: out = 1'b0;
        STATE_ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end


always @(posedge clk or posedge areset) begin
    if (areset)
        current_state <= STATE_OFF;
  
    else
        case ({j, k})
            2'b00: current_state <= STATE_OFF;
  
            2'b01: current_state <= STATE_ON;
            2'b10: current_state <= STATE_ON;
            2'b11: current_state <= STATE_OFF;
            default: ;
  
        endcase
end

endmodule
