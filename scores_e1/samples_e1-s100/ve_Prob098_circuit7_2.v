
module TopModule (
    input clk,
    input a,
    output q
);

    
    always_ff @(posedge clk) begin
        if (a) begin
            q <= 1'b1;
        end else begin
            q <= 1'b0;
        end
    end

endmodule
