
module traffic_light (
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

    parameter idle = 2'd0;
    parameter s1_red = 2'd1;
    parameter s2_yellow = 2'd2;
    parameter s3_green = 2'd3;

    reg [7:0] cnt;
    reg [1:0] state, next_state;
    reg p_red, p_yellow, p_green;
    reg p_red_prev, p_yellow_prev, p_green_prev;

    
    always @(*) begin
        case (state)
            idle: next_state = s1_red;
            s1_red: next_state = (cnt == 0) ? s3_green : s1_red;
            s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
            s3_green: next_state = (cnt == 0) ? s2_yellow : s3_green;
            default: next_state = idle;
        endcase
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
        end else begin
            state <= next_state;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10;
        end else begin
            if (pass_request && p_green && (cnt > 8'd10)) begin
                cnt <= 8'd10;
            end else if (!p_green && p_green_prev) begin
                cnt <= 8'd60;
            end else if (!p_yellow && p_yellow_prev) begin
                cnt <= 8'd5;
            end else if (!p_red && p_red_prev) begin
                cnt <= 8'd10;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p_green_prev <= 0;
            p_yellow_prev <= 0;
            p_red_prev <= 0;
        end else begin
            p_green_prev <= p_green;
            p_yellow_prev <= p_yellow;
            p_red_prev <= p_red;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            p_red <= (state == s1_red);
            p_yellow <= (state == s2_yellow);
            p_green <= (state == s3_green);
        end
    end

    assign clock = cnt;
    assign red = p_red;
    assign yellow = p_yellow;
    assign green = p_green;

endmodule
