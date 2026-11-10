
module TopModule (
    input clk,
    input d,
    input q
);

    
    reg q_reg;

    
    always @(posedge clk) begin
        if (d) begin
            q_reg <= d;
        end else begin
            q_reg <= q;
        end
    end

    
    assign q = q_reg;

endmodule
