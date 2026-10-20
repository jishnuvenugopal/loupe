
module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s, 
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    
    typedef enum {IDLE, LOW, BETWEEN_S2_S1, BETWEEN_S1_S0, HIGH} state_t;
    state_t current_state, next_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else begin
            current_state <= next_state;

            
            case (current_state)
                IDLE: begin
                    if (s[0] || s[1] || s[2]) begin
                        next_state <= BETWEEN_S2_S1;
                    end else begin
                        next_state <= LOW;
                    end
                end
                LOW: begin
                    if (s[0] || s[1] || s[2]) begin
                        next_state <= BETWEEN_S2_S1;
                    end else begin
                        next_state <= LOW;
                    end
                end
                BETWEEN_S2_S1: begin
                    if (s[0] || s[1]) begin
                        next_state <= BETWEEN_S1_S0;
                    end else begin
                        next_state <= HIGH;
                    end
                end
                BETWEEN_S1_S0: begin
                    if (s[0]) begin
                        next_state <= BETWEEN_S1_S0;
                    end else begin
                        next_state <= HIGH;
                    end
                end
                HIGH: begin
                    if (s[0] || s[1] || s[2]) begin
                        next_state <= BETWEEN_S2_S1;
                    end else begin
                        next_state <= LOW;
                    end
                end
            endcase

            
            case (current_state)
                IDLE, LOW: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
                BETWEEN_S2_S1: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
                BETWEEN_S1_S0: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
                HIGH: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
            endcase
        end
    end

endmodule
