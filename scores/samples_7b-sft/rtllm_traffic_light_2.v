
module traffic_light (
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    parameter idle = 2'b00;
    parameter s1_red = 2'b01;
    parameter s2_yellow = 2'b10;
    parameter s3_green = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] cnt;
    reg p_red, p_yellow, p_green;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            state <= next_state;
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;
        end
    end

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
            cnt <= 8'd10;
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            if (pass_request && green) begin
                if (cnt > 8'd10)
                    cnt <= 8'd10;
            end else begin
                case (state)
                    s1_red: begin
                        if (p_red)
                            cnt <= 8'd10;
                        else if (p_yellow)
                            cnt <= 8'd5;
                        else if (p_green)
                            cnt <= 8'd60;
                        else
                            cnt <= cnt - 1;
                    end
                    s2_yellow: begin
                        if (p_red)
                            cnt <= 8'd10;
                        else if (p_yellow)
                            cnt <= 8'd5;
                        else if (p_green)
                            cnt <= 8'd60;
                        else
                            cnt <= cnt - 1;
                    end
                    s3_green: begin
                        if (p_red)
                            cnt <= 8'd10;
                        else if (p_yellow)
                            cnt <= 8'd5;
                        else if (p_green)
                            cnt <= 8'd60;
                        else
                            cnt <= cnt - 1;
                    end
                    default: cnt <= cnt - 1;
                endcase
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
        end
    end

    assign clock = cnt;

endmodule
