
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

    
    reg [2:0] fr0_val = 3'b001;
    reg [2:0] fr1_val = 3'b010;
    reg [2:0] fr2_val = 3'b011;

    
    reg [2:0] fr2_reg;
    reg [2:0] fr1_reg;
    reg [2:0] fr0_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            prev_s <= 3'b000;
            current_s <= 3'b000;
            prev_level <= 3'b000;
            current_level <= 3'b000;
            fr2_reg <= 3'b000;
            fr1_reg <= 3'b000;
            fr0_reg <= 3'b000;
        end else begin
            case (state)
                2'b00: begin
                    if (s == 3'b000) begin
                        state <= 2'b00;
                    end else if (s == 3'b001) begin
                        state <= 2'b01;
                    end else if (s == 3'b010) begin
                        state <= 2'b02;
                    end else if (s == 3'b011) begin
                        state <= 2'b02;
                    end
                end
                2'b01: begin
                    if (s == 3'b000) begin
                        state <= 2'b00;
                    end else if (s == 3'b001) begin
                        state <= 2'b01;
                    end else if (s == 3'b010) begin
                        state <= 2'b02;
                    end else if (s == 3'b011) begin
                        state <= 2'b02;
                    end
                end
                2'b02: begin
                    if (s == 3'b000) begin
                        state <= 2'b00;
                    end else if (s == 3'b001) begin
                        state <= 2'b01;
                    end else if (s == 3'b010) begin
                        state <= 2'b02;
                    end else if (s == 3'b011) begin
                        state <= 2'b02;
                    end
                end
                2'b03: begin
                    if (s == 3'b000) begin
                        state <= 2'b00;
                    end else if (s == 3'b001) begin
                        state <= 2'b01;
                    end else if (s == 3'b010) begin
                        state <= 2'b02;
                    end else if (s == 3'b011) begin
                        state <= 2'b02;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk) begin
        prev_s <= current_s;
        current_s <= s;
        prev_level <= current_level;
        current_level <= s;
    end

    
    always @(posedge clk) begin
        case (state)
            2'b00: begin
                fr2_reg <= fr2_val;
                fr1_reg <= fr1_val;
                fr0_reg <= fr0_val;
            end
            2'b01: begin
                if (prev_level < current_level) begin
                    fr2_reg <= fr2_val;
                    fr1_reg <= fr1_val;
                    fr0_reg <= fr0_val;
                end else begin
                    fr2_reg <= fr2_val;
                    fr1_reg <= fr1_val;
                    fr0_reg <= fr0_val;
                end
            end
            2'b02: begin
                if (prev_level < current_level) begin
                    fr2_reg <= fr2_val;
                    fr1_reg <= fr1_val;
                    fr0_reg <= fr0_val;
                end else begin
                    fr2_reg <= fr2_val;
                    fr1_reg <= fr1_val;
                    fr0_reg <= fr0_val;
                end
            end
            2'b03: begin
                if (prev_level < current_level) begin
                    fr2_reg <= fr2_val;
                    fr1_reg <= fr1_val;
                    fr0_reg <= fr0_val;
                end else begin
                    fr2_reg <= fr2_val;
                    fr1_reg <= fr1_val;
                    fr0_reg <= fr0_val;
                end
            end
        endcase
    end

    
    assign fr2 = fr2_reg;
    assign fr1 = fr1_reg;
    assign fr0 = fr0_reg;
    assign dfr = 1'b0;

endmodule
