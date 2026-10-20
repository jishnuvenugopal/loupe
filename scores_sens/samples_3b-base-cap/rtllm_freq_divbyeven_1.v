
module freq_divbyeven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    
    parameter NUM_DIV = 6;
 

    
    `ifndef NUM_DIV_IS_EVEN
    `define NUM_DIV_IS_EVEN (NUM_DIV % 2 == 0)
    `endif

    
    `ifndef NUM_DIV_IS_VALID
    `define NUM_DIV_IS_VALID (NUM_DIV >= 2 && NUM_DIV <= 32)
    `endif

    
    `ifndef NUM_DIV_IS_VALID_OR_EVEN
    `define NUM_DIV_IS_VALID_OR_EVEN (`NUM_DIV_IS_EVEN && `NUM_DIV_IS_VALID)
    `endif

    
    `ifndef NUM_DIV_IS_VALID_OR_EVEN
    `error "NUM_DIV must be an even number between 2 and 32"
    `endif

    
    reg [3:0] cnt;

    
    always @(posedge rst_n) begin
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end

    
    always @(posedge clk) begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1'b1;
        end else begin
            cnt <= 4'b0;
            clk_div <= ~clk_div;
 
        end
    end

endmodule
