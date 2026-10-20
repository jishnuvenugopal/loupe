
module TopModule(clk, d, r, q);
    input clk;
    input d;
    input r;
    output q;

    reg q_reg;

    always @(posedge clk) begin
        if (r)
            q_reg <= 0;
        else
            q_reg <= d;
    end

    assign q = q_reg;
endmodule
