
module freq_divbyeven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    
    parameter NUM_DIV = 6;
 

    
    `ifndef NUM_DIV_IS_EVEN
    `define NUM_DIV_IS_EVEN (NUM_DIV % 2 == 0)
    `endif

    
    `ifndef NUM_DIV_IS_EVEN
    `error "NUM_DIV must be an even number"
    `endif

    
    reg [3:0] cnt;

    
    always @(posedge rst_n) begin
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end

    
    always @(posedge clk) begin
        if (rst_n) begin
            if (cnt < (NUM_DIV / 2 - 1)) begin
                cnt <= cnt + 1'b1;
            end else begin
                cnt <= 4'b0;
                clk_div <= ~clk_div;
 
            end
        end
    end

endmodule
