
module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    
    typedef enum {s0, s1, s2, s3, s4} state_t;
    state_t state;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= s0;
            MATCH <= 1'b0;
        end else begin
            case (state)
                s0: begin
                    if (IN == 1'b1) begin
                        state <= s1;
                    end else begin
                        state <= s2;
                    end
                end
                s1: begin
                    if (IN == 1'b0) begin
                        state <= s2;
                    end else begin
                        state <= s3;
                    end
                end
                s2: begin
                    if (IN == 1'b0) begin
                        state <= s2;
                    end else begin
                        state <= s3;
                    end
                end
                s3: begin
                    if (IN == 1'b1) begin
                        state <= s4;
                    end else begin
                        state <= s2;
                    end
                end
                s4: begin
                    if (IN == 1'b1) begin
                        state <= s0;
                        MATCH <= 1'b1;
                    end else begin
                        state <= s2;
                    end
                end
                default: state <= s0;
            endcase
        end
    end

endmodule
