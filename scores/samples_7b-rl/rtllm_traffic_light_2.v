
module traffic_light (
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

    
    parameter idle = 0,
              s1_red = 1,
              s2_yellow = 2,
              s3_green = 3;

    
    reg [1:0] state, next_state;
    reg [7:0] cnt;
    reg p_red, p_yellow, p_green;
    reg red_reg, yellow_reg, green_reg;

    
    assign clock = cnt;

    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
        end else begin
            state <= next_state;
        end
    end

    
    always @ (*) begin
        case (state)
            idle:    next_state = s1_red;
            s1_red:  next_state = (cnt == 0) ? s3_green : s1_red;
            s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
            s3_green: next_state = (cnt == 0) ? s2_yellow : s3_green;
            default: next_state = idle;
        endcase
    end

    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
        end else begin
            if (pass_request && green_reg) begin
                if (cnt > 10)
                    cnt <= 10;
            end else if (!green_reg && p_green) begin
                cnt <= 60;
            end else if (!yellow_reg && p_yellow) begin
                cnt <= 5;
            end else if (!red_reg && p_red) begin
                cnt <= 10;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end

    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            p_red <= red_reg;
            p_yellow <= yellow_reg;
            p_green <= green_reg;
        end
    end

    
    always @ (*) begin
        red_reg = 0;
        yellow_reg = 0;
        green_reg = 0;

        case (state)
            s1_red:    red_reg = 1;
            s3_green: green_reg = 1;
            s2_yellow: yellow_reg = 1;
            default: {red_reg, yellow_reg, green_reg} = 3'b0;
        endcase
    end

    
    assign red = p_red;
    assign yellow = p_yellow;
    assign green = p_green;

endmodule
