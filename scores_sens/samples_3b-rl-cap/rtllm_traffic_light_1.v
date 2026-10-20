
module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    
    parameter idle = 2'b00,
              s1_red = 2'b01,
              s2_yellow = 2'b10,
              s3_green = 2'b11;

    
    reg [1:0] state;
    reg [7:0] cnt;
    reg p_red, p_yellow, p_green;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd10;
            p_red <= 1'b0;
            p_yellow <= 1'b0;
            p_green <= 1'b0;
        end else begin
            case (state)
                idle: begin
                    state <= s1_red;
                    cnt <= 8'd10;
                    p_red <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                end
                s1_red: begin
                    if (cnt == 3'd3) begin
                        state <= s3_green;
                        cnt <= 8'd60;
                        p_red <= 1'b0;
                        p_yellow <= 1'b0;
                        p_green <= 1'b1;
                    end else begin
                        state <= s1_red;
                        cnt <= cnt - 1'd1;
                        p_red <= 1'b1;
                        p_yellow <= 1'b0;
                        p_green <= 1'b0;
                    end
                end
                s2_yellow: begin
                    if (cnt == 3'd3) begin
                        state <= s1_red;
                        cnt <= 8'd10;
                        p_red <= 1'b1;
                        p_yellow <= 1'b0;
                        p_green <= 1'b0;
                    end else begin
                        state <= s2_yellow;
                        cnt <= cnt - 1'd1;
                        p_red <= 1'b0;
                        p_yellow <= 1'b1;
                        p_green <= 1'b0;
                    end
                end
                s3_green: begin
                    if (cnt == 3'd3) begin
                        state <= s2_yellow;
                        cnt <= 8'd5;
                        p_red <= 1'b0;
                        p_yellow <= 1'b1;
                        p_green <= 1'b0;
                    end else begin
                        state <= s3_green;
                        cnt <= cnt - 1'd1;
                        p_red <= 1'b0;
                        p_yellow <= 1'b0;
                        p_green <= 1'b1;
                    end
                end
                default: begin
                    state <= idle;
                    cnt <= 8'd10;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                end
            endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10;
        end else begin
            if (pass_request && green) begin
                cnt <= 8'd10;
            end else if (!green && p_green) begin
                cnt <= 8'd60;
            end else if (!yellow && p_yellow) begin
                cnt <= 8'd5;
            end else if (!red && p_red) begin
                cnt <= 8'd10;
            end else begin
                cnt <= cnt - 1'd1;
            end
        end
    end

    assign clock = cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p_red <= 1'b0;
            p_yellow <= 1'b0;
            p_green <= 1'b0;
        end else begin
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end else begin
            if (state == s3_green) begin
                green <= 1'b1;
            end else begin
                green <= 1'b0;
            end
            if (state == s2_yellow) begin
                yellow <= 1'b1;
            end else begin
                yellow <= 1'b0;
            end
            if (state == s1_red) begin
                red <= 1'b1;
            end else begin
                red <= 1'b0;
            end
        end
    end

endmodule
