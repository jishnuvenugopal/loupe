
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);


localparam S0     = 4'd0,
           S1     = 4'd1,
           S2     = 4'd2,
           S3     = 4'd3,
           S4     = 4'd4,
           S5     = 4'd5,
           S6     = 4'd6,
           S7     = 4'd7,
           S_DISC = 4'd8,
           S_FLAG = 4'd9;

reg [3:0] current_state, next_state;


always @(posedge clk) begin
    if (reset)
        current_state <= S0;
    else
        current_state <= next_state;
end


always @(*) begin
    case (current_state)
        S0: next_state = in ? S1 : S0;
        S1: next_state = in ? S2 : S0;
        S2: next_state = in ? S3 : S0;
        S3: next_state = in ? S4 : S0;
        S4: next_state = in ? S5 : S0;
        S5: next_state = in ? S6 : S0;
        S6: next_state = in ? S7 : S_DISC;
        S7: next_state = in ? S7 : S_FLAG;
        S_DISC: next_state = S0;
        S_FLAG: next_state = S0;
        default: next_state = S0;
    endcase
end


always @(*) begin
    disc = 1'b0;
    flag = 1'b0;
    err  = 1'b0;
    case (current_state)
        S_DISC: disc = 1'b1;
        S_FLAG: flag = 1'b1;
        S7:     err  = 1'b1;
        default: ;
 
    endcase
end

endmodule
