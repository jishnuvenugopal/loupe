
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);


parameter [1:0] STATE_A = 2'b00;
parameter [1:0] STATE_B = 2'b01;
parameter [1:0] STATE_C = 2'b10;
parameter [1:0] STATE_D = 2'b11;


reg [1:0] current_state;
reg [1:0] next_state;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= STATE_A;
    end else begin
        current_state <= next_state;
    end
end


always @(*) begin
    case (current_state)
        STATE_A: next_state = (in == 0) ? STATE_A : STATE_B;
        STATE_B: next_state = (in == 0) ? STATE_C : STATE_B;
        STATE_C: next_state = (in == 0) ? STATE_A : STATE_D;
        STATE_D: next_state = (in == 0) ? STATE_C : STATE_B;
        default: next_state = STATE_A;
 
    endcase
end


always @(*) begin
    case (current_state)
        STATE_A: out = 0;
        STATE_B: out = 0;
        STATE_C: out = 0;
        STATE_D: out = 1;
        default: out = 0;
 
    endcase
end

endmodule
