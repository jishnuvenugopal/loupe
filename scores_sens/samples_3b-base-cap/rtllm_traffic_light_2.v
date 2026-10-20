
module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    
    typedef enum {idle, s1_red, s2_yellow, s3_green} state_t;

    
    reg [7:0] cnt;
    reg [1:0] state;
    reg [1:0] p_red, p_yellow, p_green;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 10;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            case (state)
                idle: begin
                    state <= s1_red;
                    cnt <= 10;
                    p_red <= 1;
                    p_yellow <= 0;
                    p_green <= 0;
                end
                s1_red: begin
                    if (cnt == 3) begin
                        state <= s3_green;
                        cnt <= 60;
                        p_red <= 0;
                        p_yellow <= 1;
                        p_green <= 0;
                    end else begin
                        cnt <= cnt - 1;
                        p_red <= 1;
                        p_yellow <= 0;
                        p_green <= 0;
                    end
                end
                s2_yellow: begin
                    if (cnt == 3) begin
                        state <= s1_red;
                        cnt <= 10;
                        p_red <= 1;
                        p_yellow <= 0;
                        p_green <= 0;
                    end else begin
                        cnt <= cnt - 1;
                        p_red <= 0;
                        p_yellow <= 1;
                        p_green <= 0;
                    end
                end
                s3_green: begin
                    if (cnt == 3) begin
                        state <= s2_yellow;
                        cnt <= 5;
                        p_red <= 0;
                        p_yellow <= 1;
                        p_green <= 0;
                    end else begin
                        cnt <= cnt - 1;
                        p_red <= 0;
                        p_yellow <= 0;
                        p_green <= 1;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
        end else begin
            if (pass_request && green) begin
                cnt <= 10;
            end else if (!green && p_green) begin
                cnt <= 60;
            end else if (!yellow && p_yellow) begin
                cnt <= 5;
            end else if (!red && p_red) begin
                cnt <= 10;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end

    
    assign clock = cnt;
    assign red = p_red;
    assign yellow = p_yellow;
    assign green = p_green;

endmodule
