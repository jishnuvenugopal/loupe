
module traffic_light(
    input wire rst_n,  
    input wire clk,    
    input wire pass_request,  
    output reg [7:0] clock,  
    output reg red,    
    output reg yellow, 
    output reg green   
);


localparam [1:0] idle = 2'b00,
                s1_red = 2'b01,
                s2_yellow = 2'b10,
                s3_green = 2'b11;


reg [7:0] cnt;
  
reg [1:0] state;
  
reg [1:0] next_state;
  
reg p_red, p_yellow, p_green;
  


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end


always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 5) next_state = s3_green;
 else next_state = s1_red;
        s2_yellow: if (cnt == 2) next_state = s1_red;
 else next_state = s2_yellow;
        s3_green: if (cnt == 9) next_state = s2_yellow;
 else next_state = s3_green;
        default: next_state = idle;
    endcase
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
        p_green <= 0;
    end else if (pass_request && green) begin
        cnt <= 8'd10;
        p_green <= 0;
    end else if (!green && p_green) begin
        cnt <= 8'd60;
        p_green <= 0;
    end else if (!yellow && p_yellow) begin
        cnt <= 8'd5;
        p_yellow <= 0;
    end else if (!red && p_red) begin
        cnt <= 8'd10;
        p_red <= 0;
    end else begin
        cnt <= cnt - 1;
    end
    p_green <= green;
    p_yellow <= yellow;
    p_red <= red;
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
        clock <= 8'd10;
    end else begin
        case (state)
            idle: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
                clock <= 8'd10;
            end
            s1_red: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
                clock <= cnt;
            end
            s2_yellow: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
                clock <= cnt;
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
                clock <= cnt;
            end
            default: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
                clock <= 8'd10;
            end
        endcase
    end
end

endmodule
