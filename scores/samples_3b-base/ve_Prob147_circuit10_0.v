
module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    
    reg q_reg;

    
    always @(posedge clk) begin
        if (q_reg == 0) begin
            if (a == 1 && b == 0) begin
                state = 1;
            end else begin
                state = 0;
            end
        end else begin
            if (a == 0 && b == 1) begin
                state = 0;
            end else begin
                state = 1;
            end
        end
    end

    
    assign q = q_reg;

endmodule
