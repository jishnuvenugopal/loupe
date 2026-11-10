
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    
    typedef enum {STATE_LOW, STATE_MIDDLE, STATE_HIGH} state_t;

    
    state_t state;
    reg [2:0] prev_s;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_LOW;
            prev_s <= 3'b000;
        end else begin
            case (state)
                STATE_LOW:
                    if (s[2]) begin
                        state <= STATE_MIDDLE;
                        prev_s <= s;
                    end
                STATE_MIDDLE:
                    if (s[1] && s[2]) begin
                        state <= STATE_HIGH;
                        prev_s <= s;
                    end else if (s[0] && s[1]) begin
                        state <= STATE_MIDDLE;
                        prev_s <= s;
                    end else if (s[0]) begin
                        state <= STATE_LOW;
                        prev_s <= s;
                    end
                STATE_HIGH:
                    if (s[0]) begin
                        state <= STATE_MIDDLE;
                        prev_s <= s;
                    end
                default:
                    state <= STATE_LOW;
                    prev_s <= s;
            endcase
        end
    end

    
    always @(*) begin
        case (state)
            STATE_LOW:
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            STATE_MIDDLE:
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            STATE_HIGH:
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
        endcase
    end

endmodule
