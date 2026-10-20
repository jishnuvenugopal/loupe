
module TopModule (
    input  clk,
    input  d,
    output q
);

    
    reg q_reg;

    
    reg rst;

    
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            
            q_reg <= 1'b0;
        end else begin
            
            q_reg <= ~q_reg;
        end
    end

    
    assign q = q_reg;

endmodule
