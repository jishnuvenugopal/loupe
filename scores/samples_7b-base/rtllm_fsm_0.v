
module fsm(
    input wire IN,       
    input wire CLK,      
    input wire RST,      
    output reg MATCH      
);


parameter IDLE = 0,
           STATE1 = 1,
           STATE2 = 2,
           STATE3 = 3,
           MATCHED = 4;

reg [1:0] current_state, next_state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == MATCHED) begin
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

always @(*) begin
    next_state = current_state;
    case (current_state)
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
                next_state = MATCHED;
            end else begin
                next_state = IDLE;
            end
        end
        MATCHED: begin
            
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule
