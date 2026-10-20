
module fsm (
    input IN,
    input CLK,
    input RST,
    output MATCH
);


parameter S0 = 3'd0;
parameter S1 = 3'd1;
parameter S2 = 3'd2;
parameter S3 = 3'd3;
parameter S4 = 3'd4;

reg [2:0] current_state, next_state;


always @(posedge CLK or posedge RST) begin
    if (RST)
        current_state <= S0;
    else
        current_state <= next_state;
end


always @(*) begin
    case (current_state)
        S0: next_state = (IN) ? S1 : S0;
        S1: next_state = (IN) ? S1 : S2;
        S2: next_state = (IN) ? S1 : S3;
        S3: next_state = (IN) ? S4 : S2;
        S4: next_state = (IN) ? S1 : S0;
        default: next_state = S0;
    endcase
end


assign MATCH = (current_state == S4) & IN;

endmodule
