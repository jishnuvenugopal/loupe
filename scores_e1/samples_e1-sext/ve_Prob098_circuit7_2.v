
module TopModule (
    input clk,
    input a,
    output reg q
);

    
    reg q_reg = 1'b0;

    
    always @(posedge clk) begin
        if (a == 1'b1) begin
            q_reg <= ~q_reg;
        end
    end

    
    assign q = q_reg;

endmodule
