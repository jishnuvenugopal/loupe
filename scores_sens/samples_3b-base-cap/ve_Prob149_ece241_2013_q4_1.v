
module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s, 
    output reg fr2, 
    output reg fr1, 
    output reg fr0, 
    output reg dfr   
);

    
    typedef enum {IDLE, LOW, BETWEEN_S1_S2, BETWEEN_S2_S0, HIGH} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = IDLE;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            fr0 <= 1'b0;
            fr1 <= 1'b0;
            fr2 <= 1'b0;
            dfr <= 1'b0;
        end else begin
            current_state <= next_state;

            
            case (current_state)
                IDLE: begin
                    if (s[0] || s[1] || s[2]) begin
                        next_state = LOW;
                    end else begin
                        next_state = IDLE;
                    end
                end
                LOW: begin
                    if (s[0] || s[1] || s[2]) begin
                        next_state = BETWEEN_S1_S2;
                    end else begin
                        next_state = IDLE;
                    end
                end
                BETWEEN_S1_S2: begin
                    if (s[0] || s[1]) begin
                        next_state = BETWEEN_S2_S0;
                    end else begin
                        next_state = IDLE;
                    end
                end
                BETWEEN_S2_S0: begin
                    if (s[0]) begin
                        next_state = HIGH;
                    end else begin
                        next_state = IDLE;
                    end
                end
                HIGH: begin
                    if (s[0] || s[1] || s[2]) begin
                        next_state = BETWEEN_S1_S2;
                    end else begin
                        next_state = IDLE;
                    end
                end
            endcase

            
            case (current_state)
                IDLE: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                    dfr <= 1'b0;
                end
                LOW: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b1;
                    dfr <= 1'b0;
                end
                BETWEEN_S1_S2: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                    dfr <= 1'b0;
                end
                BETWEEN_S2_S0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                    dfr <= 1'b0;
                end
                HIGH: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                    dfr <= 1'b0;
                end
            endcase
        end
    end

endmodule
