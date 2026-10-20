
module traffic_light (
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

    
    localparam [1:0] idle      = 0,
                     s1_red    = 1,
                     s2_yellow = 2,
                     s3_green  = 3;

    
    reg [1:0] state, next_state;
    reg [7:0] cnt;
    reg p_red, p_yellow, p_green;
    reg p_green_prev, p_yellow_prev, p_red_prev;

    
    assign clock = cnt;
    assign red = p_red;
    assign yellow = p_yellow;
    assign green = p_green;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= idle;
        else state <= next_state;
    end

    
    always @* begin
        next_state = state;
        case (state)
            idle:       next_state = s1_red;
            s1_red:     next_state = (cnt == 0) ? s3_green : s1_red;
            s3_green:   next_state = (cnt == 0) ? s2_yellow : s3_green;
            s2_yellow:  next_state = (cnt == 0) ? s1_red : s2_yellow;
            default:    next_state = idle;
        endcase
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
        end else begin
            if (pass_request && p_green && (cnt > 10)) begin
                cnt <= 10;
            end else begin
                
                p_green_prev <= p_green;
                p_yellow_prev <= p_yellow;
                p_red_prev <= p_red;

                case (state)
                    s1_red:    cnt <= (cnt ==0) ? 10 : (cnt -1);
                    s3_green:  cnt <= (cnt ==0) ? 60 : (cnt -1);
                    s2_yellow: cnt <= (cnt ==0) ? 5 : (cnt -1);
                    default:   cnt <= (state == s1_red || state == s3_green || state == s2_yellow) ? 10 : cnt;
                endcase

                
                if (state != s3_green && next_state == s3_green)
                    cnt <= 60;
                else if (state != s2_yellow && next_state == s2_yellow)
                    cnt <=5;
                else if (state != s1_red && next_state == s1_red)
                    cnt <=10;
            end
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p_red <= 0;
            p_yellow <=0;
            p_green <=0;
        end else begin
            p_red <= (state == s1_red);
            p_yellow <= (state == s2_yellow);
            p_green <= (state == s3_green);
        end
    end

endmodule
