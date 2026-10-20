
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

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= idle;
        else
            case (state)
                idle: begin
                    if (pass_request) begin
                        state <= s1_red;
 
                    end else begin
                        state <= s1_red;
 
                    end
                end
                s1_red: begin
                    if (cnt == 3) begin
                        state <= s3_green;
                    end else begin
                        state <= s1_red;
                    end
                end
                s2_yellow: begin
                    if (cnt == 3) begin
                        state <= s1_red;
                    end else begin
                        state <= s2_yellow;
                    end
                end
                s3_green: begin
                    if (cnt == 3) begin
                        state <= s2_yellow;
                    end else begin
                        state <= s3_green;
                    end
                end
                default: state <= idle;
            endcase
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 8'd10;
        else if (pass_request && green)
            cnt <= 8'd10;
        else if (!green && p_green)
            cnt <= 8'd60;
        else if (!yellow && p_yellow)
            cnt <= 8'd5;
        else if (!red && p_red)
            cnt <= 8'd10;
        else
            cnt <= cnt - 1;
    end

    
    assign clock = cnt;

    
    reg p_red, p_yellow, p_green;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            p_red <= 1'b0;
        else
            p_red <= red;
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            p_yellow <= 1'b0;
        else
            p_yellow <= yellow;
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            p_green <= 1'b0;
        else
            p_green <= green;
    end
    assign red = p_red;
    assign yellow = p_yellow;
    assign green = p_green;

endmodule
