
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    
    typedef enum {Idle, AboveS2, BetweenS2AndS1, BetweenS1AndS0, BelowS0} state_t;

    
    state_t state;

    
    reg [2:0] prev_s;

    
    reg [2:0] fr;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= Idle;
            prev_s <= 3'b000;
            fr <= 3'b000;
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else begin
            case (state)
                Idle: begin
                    if (s[2] == 3'b111) begin
                        state <= AboveS2;
                        prev_s <= s;
                    end else if (s[1] == 3'b111) begin
                        state <= BetweenS2AndS1;
                        prev_s <= s;
                    end else if (s[0] == 3'b111) begin
                        state <= BetweenS1AndS0;
                        prev_s <= s;
                    end else begin
                        state <= Idle;
                    end
                end
                AboveS2: begin
                    if (s[2] == 3'b111) begin
                        state <= AboveS2;
                        prev_s <= s;
                    end else if (s[1] == 3'b111) begin
                        state <= BetweenS2AndS1;
                        prev_s <= s;
                    end else if (s[0] == 3'b111) begin
                        state <= BetweenS1AndS0;
                        prev_s <= s;
                    end else begin
                        state <= Idle;
                    end
                end
                BetweenS2AndS1: begin
                    if (s[2] == 3'b111) begin
                        state <= AboveS2;
                        prev_s <= s;
                    end else if (s[1] == 3'b111) begin
                        state <= BetweenS2AndS1;
                        prev_s <= s;
                    end else if (s[0] == 3'b111) begin
                        state <= BetweenS1AndS0;
                        prev_s <= s;
                    end else begin
                        state <= Idle;
                    end
                end
                BetweenS1AndS0: begin
                    if (s[2] == 3'b111) begin
                        state <= AboveS2;
                        prev_s <= s;
                    end else if (s[1] == 3'b111) begin
                        state <= BetweenS2AndS1;
                        prev_s <= s;
                    end else if (s[0] == 3'b111) begin
                        state <= BetweenS1AndS0;
                        prev_s <= s;
                    end else begin
                        state <= Idle;
                    end
                end
                BelowS0: begin
                    if (s[2] == 3'b111) begin
                        state <= AboveS2;
                        prev_s <= s;
                    end else if (s[1] == 3'b111) begin
                        state <= BetweenS2AndS1;
                        prev_s <= s;
                    end else if (s[0] == 3'b111) begin
                        state <= BetweenS1AndS0;
                        prev_s <= s;
                    end else begin
                        state <= Idle;
                    end
                end
            endcase

            
            case (state)
                Idle: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
                AboveS2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
                BetweenS2AndS1: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
                BetweenS1AndS0: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
                BelowS0: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
            endcase

            
            prev_s <= s;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        case (state)
            Idle: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            AboveS2: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            BetweenS2AndS1: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            BetweenS1AndS0: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            BelowS0: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end

endmodule
