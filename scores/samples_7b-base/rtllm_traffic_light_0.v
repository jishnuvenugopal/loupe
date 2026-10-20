
module traffic_light(
    input wire rst_n,      
    input wire clk,        
    input wire pass_request, 

    output reg [7:0] clock,  
    output reg red,          
    output reg yellow,       
    output reg green         
);

    
    localparam idle = 2'b00,
               s1_red = 2'b01,
               s2_yellow = 2'b10,
               s3_green = 2'b11;

    
    reg [7:0] cnt;
            
    reg [1:0] state;
          
    reg p_red, p_yellow, p_green;
 

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            case (state)
                idle: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 0;
                    if (cnt == 0) state <= s1_red;
                end
                s1_red: begin
                    red <= 1;
                    if (cnt == 0) state <= s3_green;
                end
                s2_yellow: begin
                    yellow <= 1;
                    if (cnt == 0) state <= s1_red;
                end
                s3_green: begin
                    green <= 1;
                    if (cnt == 0) state <= s2_yellow;
                end
                default: state <= idle;
            endcase
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 10;
        else begin
            if (pass_request && green) cnt <= 10;
            else if (!green && p_green) cnt <= 60;
            else if (!yellow && p_yellow) cnt <= 5;
            else if (!red && p_red) cnt <= 10;
            else cnt <= cnt - 1;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;
        end
    end

    
    assign clock = cnt;
endmodule
