
module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;
        end else begin
            Q <= j ^ k;
        end
    end

endmodule
