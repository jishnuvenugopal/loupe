
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  [3:0] count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    
    reg [3:0] delay;
    reg [3:0] count_reg;
    reg       state;
    reg       pattern_found;
    reg       timer_active;
    reg       ack_active;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            pattern_found <= 0;
            timer_active <= 0;
            ack_active <= 0;
            count_reg <= 0;
        end else begin
            case (state)
                0: begin 
                    if (data == 4'b1101) begin
                        state <= 1;
                        pattern_found <= 1;
                    end else begin
                        state <= 0;
                        pattern_found <= 0;
                    end
                end
                1: begin 
                    if (data == 4'b1101) begin
                        state <= 1;
                        pattern_found <= 1;
                    end else begin
                        delay[3] <= data;
                        state <= 2;
                        pattern_found <= 0;
                    end
                end
                2: begin 
                    if (data == 4'b1101) begin
                        state <= 1;
                        pattern_found <= 1;
                    end else begin
                        delay[2] <= data;
                        state <= 3;
                        pattern_found <= 0;
                    end
                end
                3: begin 
                    if (data == 4'b1101) begin
                        state <= 1;
                        pattern_found <= 1;
                    end else begin
                        delay[1] <= data;
                        state <= 4;
                        pattern_found <= 0;
                    end
                end
                4: begin 
                    if (data == 4'b1101) begin
                        state <= 1;
                        pattern_found <= 1;
                    end else begin
                        delay[0] <= data;
                        state <= 5;
                        pattern_found <= 0;
                    end
                end
                5: begin 
                    if (timer_active) begin
                        count_reg <= count_reg - 1;
                        state <= 5;
                    end else begin
                        state <= 6;
                    end
                end
                6: begin 
                    done <= 1;
                    state <= 7;
                end
                7: begin 
                    if (ack) begin
                        state <= 0;
                        ack_active <= 1;
                    end else begin
                        state <= 7;
                        ack_active <= 0;
                    end
                end
                default: state <= 0;
            endcase
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count_reg <= 0;
            timer_active <= 0;
        end else begin
            case (state)
                1: begin 
                    delay[3] <= data;
                    count_reg <= delay;
                    timer_active <= 1;
                    state <= 5;
                    pattern_found <= 0;
                end
                2: begin 
                    delay[2] <= data;
                    count_reg <= delay;
                    timer_active <= 1;
                    state <= 5;
                    pattern_found <= 0;
                end
                3: begin 
                    delay[1] <= data;
                    count_reg <= delay;
                    timer_active <= 1;
                    state <= 5;
                    pattern_found <= 0;
                end
                4: begin 
                    delay[0] <= data;
                    count_reg <= delay;
                    timer_active <= 1;
                    state <= 5;
                    pattern_found <= 0;
                end
                5: begin 
                    count_reg <= count_reg - 1;
                    state <= 5;
                end
                default: count_reg <= 0;
            endcase
        end
    end

    
    always @(*) begin
        if (state == 5) begin
            count = count_reg;
            counting = 1;
        end else begin
            count = 4'b0000;
            counting = 0;
        end
        done = (state == 6);
        ack_active = ack;
    end

endmodule
