
module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

    
    always @(posedge clk) begin
        if (j == 1) begin
            Q <= 1;
        end else if (k == 1) begin
            Q <= ~Q;
        end else begin
            Q <= Q;
        end
    end

endmodule
