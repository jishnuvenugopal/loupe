
module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);


localparam IDLE = 3'b000,
             STATE1 = 3'b001,
             STATE2 = 3'b010,
             STATE3 = 3'b011,
             STATE4 = 3'b100,
             STATE5 = 3'b101;


reg [2:0] state, next_state;


assign MATCH = (state == STATE5) ? 1 : 0;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 0;
    end else begin
        state <= next_state;
    end
end


always @(*) begin
    next_state = state;
    case (state)
        IDLE: begin
            if (IN == 1) begin
                next_state = STATE1;
            end
        end
        STATE1: begin
            if (IN == 0) begin
                next_state = STATE2;
            end
        end
        STATE2: begin
            if (IN == 0) begin
                next_state = STATE3;
            end
        end
        STATE3: begin
            if (IN == 1) begin
                next_state = STATE4;
            end
        end
        STATE4: begin
            if (IN == 1) begin
                next_state = STATE5;
            end
        end
        STATE5: begin
            if (IN == 0) begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule
