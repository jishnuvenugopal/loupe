
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg [2:0] fr2,
    output reg [2:0] fr1,
    output reg [2:0] fr0,
    output reg dfr
);

    reg [2:0] state;
    reg [2:0] prev_level;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= Idle;
            prev_level <= 3'b000;
            fr2 <= 3'b000;
            fr1 <= 3'b000;
            fr0 <= 3'b000;
            dfr <= 1'b0;
        end else begin
            case (state)
                Idle: begin
                    if (s[2]) begin
                        state <= HighLevel;
                    end else if (s[1]) begin
                        state <= MidLevel;
                    end else if (s[0]) begin
                        state <= LowLevel;
                    end
                end
                HighLevel: begin
                    if (s[2]) begin
                        state <= HighLevel;
                    end else if (s[1]) begin
                        state <= MidLevel;
                    end else if (s[0]) begin
                        state <= LowLevel;
                    end
                end
                MidLevel: begin
                    if (s[2]) begin
                        state <= HighLevel;
                    end else if (s[1]) begin
                        state <= MidLevel;
                    end else if (s[0]) begin
                        state <= LowLevel;
                    end
                end
                LowLevel: begin
                    if (s[2]) begin
                        state <= HighLevel;
                    end else if (s[1]) begin
                        state <= MidLevel;
                    end else if (s[0]) begin
                        state <= LowLevel;
                    end
                end
            endcase

            if (state == HighLevel) begin
                fr2 <= 3'b000;
                fr1 <= 3'b000;
                fr0 <= 3'b000;
                dfr <= 1'b0;
            end else if (state == MidLevel) begin
                fr2 <= 3'b000;
                fr1 <= 3'b000;
                fr0 <= 3'b000;
                dfr <= 1'b0;
            end else if (state == LowLevel) begin
                fr2 <= 3'b000;
                fr1 <= 3'b000;
                fr0 <= 3'b000;
                dfr <= 1'b0;
            end else if (state == HighLevel) begin
                if (prev_level < s[2]) begin
                    fr2 <= 3'b000;
                    fr1 <= 3'b000;
                    fr0 <= 3'b000;
                    dfr <= 1'b1;
                end else begin
                    fr2 <= 3'b000;
                    fr1 <= 3'b000;
                    fr0 <= 3'b000;
                    dfr <= 1'b0;
                end
            end else if (state == MidLevel) begin
                if (prev_level < s[2]) begin
                    fr2 <= 3'b000;
                    fr1 <= 3'b000;
                    fr0 <= 3'b000;
                    dfr <= 1'b1;
                end else if (prev_level < s[1]) begin
                    fr2 <= 3'b000;
                    fr1 <= 3'b000;
                    fr0 <= 3'b000;
                    dfr <= 1'b1;
                end else begin
                    fr2 <= 3'b000;
                    fr1 <= 3'b000;
                    fr0 <= 3'b000;
                    dfr <= 1'b0;
                end
            end else if (state == LowLevel) begin
                if (prev_level < s[1]) begin
                    fr2 <= 3'b000;
                    fr1 <= 3'b000;
                    fr0 <= 3'b000;
                    dfr <= 1'b1;
                end else if (prev_level < s[0]) begin
                    fr2 <= 3'b000;
                    fr1 <= 3'b000;
                    fr0 <= 3'b000;
                    dfr <= 1'b1;
                end else begin
                    fr2 <= 3'b000;
                    fr1 <= 3'b000;
                    fr0 <= 3'b000;
                    dfr <= 1'b0;
                end
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_level <= 3'b000;
        end else begin
            prev_level <= s;
        end
    end

endmodule
