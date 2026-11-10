
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    
    reg [1:0] state;
    reg [2:0] prev_s;
    reg [2:0] current_s;
    reg [2:0] prev_level;
    reg [2:0] current_level;

    
    reg [2:0] fr0_val;
    reg [2:0] fr1_val;
    reg [2:0] fr2_val;
    reg [2:0] dfr_val;

    
    always @(*) begin
        state = 2'b00;
        prev_s = 3'b000;
        current_s = 3'b000;
        prev_level = 3'b000;
        current_level = 3'b000;
        fr0_val = 3'b000;
        fr1_val = 3'b000;
        fr2_val = 3'b000;
        dfr_val = 3'b000;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state = 2'b00;
            prev_s = 3'b000;
            current_s = 3'b000;
            prev_level = 3'b000;
            current_level = 3'b000;
            fr0_val = 3'b000;
            fr1_val = 3'b000;
            fr2_val = 3'b000;
            dfr_val = 3'b000;
        end else begin
            case (state)
                2'b00: begin
                    if (s[2] == 3'b111) begin
                        state = 2'b01;
                        prev_s = s;
                        current_s = s;
                        prev_level = s;
                        current_level = s;
                    end
                end
                2'b01: begin
                    if (s[2] == 3'b000) begin
                        state = 2'b00;
                        prev_s = s;
                        current_s = s;
                        prev_level = s;
                        current_level = s;
                    end
                    if (s[2] == 3'b111) begin
                        state = 2'b01;
                        prev_s = s;
                        current_s = s;
                        prev_level = s;
                        current_level = s;
                    end
                end
                2'b10: begin
                    if (s[2] == 3'b000) begin
                        state = 2'b00;
                        prev_s = s;
                        current_s = s;
                        prev_level = s;
                        current_level = s;
                    end
                    if (s[2] == 3'b111) begin
                        state = 2'b01;
                        prev_s = s;
                        current_s = s;
                        prev_level = s;
                        current_level = s;
                    end
                end
                2'b11: begin
                    if (s[2] == 3'b000) begin
                        state = 2'b00;
                        prev_s = s;
                        current_s = s;
                        prev_level = s;
                        current_level = s;
                    end
                    if (s[2] == 3'b111) begin
                        state = 2'b01;
                        prev_s = s;
                        current_s = s;
                        prev_level = s;
                        current_level = s;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fr0_val = 3'b000;
            fr1_val = 3'b000;
            fr2_val = 3'b000;
            dfr_val = 3'b000;
        end else begin
            case (state)
                2'b00: begin
                    fr0_val = 3'b000;
                    fr1_val = 3'b000;
                    fr2_val = 3'b000;
                    dfr_val = 3'b000;
                end
                2'b01: begin
                    if (prev_level < current_level) begin
                        fr0_val = 3'b000;
                        fr1_val = 3'b000;
                        fr2_val = 3'b000;
                        dfr_val = 3'b000;
                    end else begin
                        fr0_val = 3'b000;
                        fr1_val = 3'b000;
                        fr2_val = 3'b000;
                        dfr_val = 3'b000;
                    end
                end
                2'b10: begin
                    if (prev_level < current_level) begin
                        fr0_val = 3'b000;
                        fr1_val = 3'b000;
                        fr2_val = 3'b000;
                        dfr_val = 3'b000;
                    end else begin
                        fr0_val = 3'b000;
                        fr1_val = 3'b000;
                        fr2_val = 3'b000;
                        dfr_val = 3'b000;
                    end
                end
                2'b11: begin
                    if (prev_level < current_level) begin
                        fr0_val = 3'b000;
                        fr1_val = 3'b000;
                        fr2_val = 3'b000;
                        dfr_val = 3'b000;
                    end else begin
                        fr0_val = 3'b000;
                        fr1_val = 3'b000;
                        fr2_val = 3'b000;
                        dfr_val = 3'b000;
                    end
                end
            endcase
        end
    end

    
    assign fr2 = fr2_val;
    assign fr1 = fr1_val;
    assign fr0 = fr0_val;
    assign dfr = dfr_val;

endmodule
