
module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    
    typedef enum {IDLE, MATCH} state_t;

    
    state_t state = IDLE;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= IDLE;
            MATCH <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (IN == 1) begin
                        state <= MATCH;
                        MATCH <= 1;
                    end else begin
                        state <= IDLE;
                        MATCH <= 0;
                    end
                end
                MATCH: begin
                    if (IN == 1) begin
                        state <= MATCH;
                        MATCH <= 1;
                    end else begin
                        state <= IDLE;
                        MATCH <= 0;
                    end
                end
            endcase
        end
    end

endmodule
