
module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

    
    typedef enum {S0, S1, S2, S3, S4, S5} state_t;
    reg [5:0] state;

    
    reg seq_match;

    
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 0;
        end else begin
            case (state)
                S0: begin
                    if (IN == 1'b1) begin
                        state <= S1;
                    end else begin
                        state <= S0;
                    end
                end
                S1: begin
                    if (IN == 1'b0) begin
                        state <= S2;
                    end else begin
                        state <= S0;
                    end
                end
                S2: begin
                    if (IN == 1'b0) begin
                        state <= S3;
                    end else begin
                        state <= S0;
                    end
                end
                S3: begin
                    if (IN == 1'b1) begin
                        state <= S4;
                    end else begin
                        state <= S0;
                    end
                end
                S4: begin
                    if (IN == 1'b0) begin
                        state <= S5;
                    end else begin
                        state <= S0;
                    end
                end
                S5: begin
                    if (IN == 1'b1) begin
                        state <= S5;
                        seq_match <= 1'b1;
                    end else begin
                        state <= S0;
                        seq_match <= 1'b0;
                    end
                end
                default: begin
                    state <= S0;
                    MATCH <= 0;
                end
            endcase
        end
    end

    
    always @(*) begin
        if (seq_match)
            MATCH = 1'b1;
        else
            MATCH = 1'b0;
    end

endmodule
