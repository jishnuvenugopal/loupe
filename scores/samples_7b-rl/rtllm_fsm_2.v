
module fsm (
    input IN,
    input CLK,
    input RST,
    output MATCH
);

    reg [2:0] state, next_state;
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;

    
    always @ (posedge CLK, posedge RST, IN) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    
    always @ * begin
        case (state)
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S1 : S2;
            S2: next_state = IN ? S1 : S3;
            S3: next_state = IN ? S4 : S0;
            S4: next_state = IN ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    
    assign MATCH = (state == S4) && IN;

endmodule
