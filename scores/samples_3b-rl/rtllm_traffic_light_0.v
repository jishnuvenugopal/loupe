
module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    
    parameter idle = 2'b00;
    parameter s1_red = 2'b01;
    parameter s2_yellow = 2'b10;
    parameter s3_green = 2'b11;

    
    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10;
            state <= idle;
            p_red <= 1'b0;
            p_yellow <= 1'b0;
            p_green <= 1'b0;
        end else begin
            case (state)
                idle: begin
                    cnt <= 8'd10;
                    state <= s1_red;
                    p_red <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                end
                s1_red: begin
                    if (cnt == 8'd3) begin
                        cnt <= 8'd10;
                        state <= s3_green;
                    end
                    else begin
                        cnt <= cnt - 1;
                        p_red <= 1'b1;
                        p_yellow <= 1'b0;
                        p_green <= 1'b0;
                    end
                end
                s2_yellow: begin
                    if (cnt == 8'd3) begin
                        cnt <= 8'd10;
                        state <= s1_red;
                    end
                    else begin
                        cnt <= cnt - 1;
                        p_red <= 1'b0;
                        p_yellow <= 1'b1;
                        p_green <= 1'b0;
                    end
                end
                s3_green: begin
                    if (cnt == 8'd3) begin
                        cnt <= 8'd10;
                        state <= s2_yellow;
                    end
                    else begin
                        cnt <= cnt - 1;
                        p_red <= 1'b0;
                        p_yellow <= 1'b0;
                        p_green <= 1'b1;
                    end
                end
                default: begin
                    cnt <= 8'd10;
                    state <= idle;
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
            if (pass_request && p_green) begin
                cnt <= 8'd10;
            end else if (!p_green && p_green) begin
                cnt <= 8'd60;
            end else if (!p_yellow && p_yellow) begin
                cnt <= 8'd5;
            end else if (!p_red && p_red) begin
                cnt <= 8'd10;
            end else begin
                cnt <= cnt - 1;
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
            p_red <= state[0];
            p_yellow <= state[1];
            p_green <= state[0] ^ state[1];
        end
    end

    assign red = p_red;
    assign yellow = p_yellow;
    assign green = p_green;

endmodule
