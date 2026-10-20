module fsm (
    input IN,
    input CLK,
    input RST,
    output MATCH
);

    reg [2:0] state, next_state;

    localparam IDLE = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = IN ? S1 : IDLE;
            S1: next_state = IN ? S1 : S2;
            S2: next_state = IN ? IDLE : S3;
            S3: next_state = IN ? S4 : IDLE;
            S4: next_state = IN ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    assign MATCH = (state == S4) && IN;

endmodule