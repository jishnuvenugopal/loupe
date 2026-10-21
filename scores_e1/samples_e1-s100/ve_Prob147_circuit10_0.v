
module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

    
    reg q_reg;

    
    always @(posedge clk) begin
        
        if (a && b) begin
            q_reg <= 1'b1;
        end else if (a || b) begin
            q_reg <= 1'b0;
        end else begin
            q_reg <= q_reg;
 
        end
    end

    
    assign q = q_reg;
    assign state = q_reg;

endmodule
