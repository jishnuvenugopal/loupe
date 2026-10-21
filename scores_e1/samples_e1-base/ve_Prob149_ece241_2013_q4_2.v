
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg [2:0] fr2,
    output reg [2:0] fr1,
    output reg [2:0] fr0,
    output reg dfr
);

    
    typedef enum {low, between1, between2, high} state_t;

    
    state_t state;

    
    reg [2:0] current_level;
    reg [2:0] previous_level;

    
    reg [2:0] fr2_reg;
    reg [2:0] fr1_reg;
    reg [2:0] fr0_reg;
    reg [2:0] dfr_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= low;
            current_level <= 3'b000;
            previous_level <= 3'b000;
            fr2_reg <= 3'b000;
            fr1_reg <= 3'b000;
            fr0_reg <= 3'b000;
            dfr_reg <= 1'b0;
        end else begin
            case (state)
                low: begin
                    if (s[2]) begin
                        state <= between1;
                        current_level <= s[2];
                        previous_level <= s[2];
                    end
                end
                between1: begin
                    if (s[1]) begin
                        state <= between2;
                        current_level <= s[1];
                        previous_level <= s[1];
                    end else if (s[2]) begin
                        state <= high;
                        current_level <= s[2];
                        previous_level <= s[1];
                    end
                end
                between2: begin
                    if (s[0]) begin
                        state <= high;
                        current_level <= s[0];
                        previous_level <= s[0];
                    end
                end
                high: begin
                    if (s[0]) begin
                        state <= between1;
                        current_level <= s[0];
                        previous_level <= s[0];
                    end
                end
            endcase

            
            case (state)
                low: begin
                    fr2_reg <= 3'b000;
                    fr1_reg <= 3'b000;
                    fr0_reg <= 3'b000;
                    dfr_reg <= 1'b0;
                end
                between1: begin
                    if (previous_level < current_level) begin
                        fr2_reg <= 3'b000;
                        fr1_reg <= 3'b000;
                        fr0_reg <= 3'b000;
                        dfr_reg <= 1'b1;
                    end else begin
                        fr2_reg <= 3'b000;
                        fr1_reg <= 3'b000;
                        fr0_reg <= 3'b000;
                        dfr_reg <= 1'b0;
                    end
                end
                between2: begin
                    if (previous_level < current_level) begin
                        fr2_reg <= 3'b000;
                        fr1_reg <= 3'b000;
                        fr0_reg <= 3'b000;
                        dfr_reg <= 1'b1;
                    end else begin
                        fr2_reg <= 3'b000;
                        fr1_reg <= 3'b000;
                        fr0_reg <= 3'b000;
                        dfr_reg <= 1'b0;
                    end
                end
                high: begin
                    if (previous_level < current_level) begin
                        fr2_reg <= 3'b000;
                        fr1_reg <= 3'b000;
                        fr0_reg <= 3'b000;
                        dfr_reg <= 1'b1;
                    end else begin
                        fr2_reg <= 3'b000;
                        fr1_reg <= 3'b000;
                        fr0_reg <= 3'b000;
                        dfr_reg <= 1'b0;
                    end
                end
            endcase

            
            fr2 <= fr2_reg;
            fr1 <= fr1_reg;
            fr0 <= fr0_reg;
            dfr <= dfr_reg;
        end
    end

endmodule
