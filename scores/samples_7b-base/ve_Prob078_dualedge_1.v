
module TopModule (
    input clk,
    input d,
    output reg q
);
    
    reg clk_rising;
    reg clk_falling;

    
    always @(posedge clk) begin
        clk_rising <= 1;
        clk_falling <= 0;
    end

    
    always @(negedge clk) begin
        clk_falling <= 1;
        clk_rising <= 0;
    end

    
    always @(posedge clk or negedge clk) begin
        if (clk_rising) begin
            q <= d;
        end else if (clk_falling) begin
            q <= d;
        end
    end
endmodule
