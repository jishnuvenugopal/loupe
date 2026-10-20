
module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    
    reg q_reg;

    
    always @(posedge clk) begin
        if (a == 1 && b == 1) begin
            q_reg <= 1'b1;
        end else begin
            q_reg <= 1'b0;
        end
    end

    
    assign q = q_reg;

    
    assign state = q;

endmodule
