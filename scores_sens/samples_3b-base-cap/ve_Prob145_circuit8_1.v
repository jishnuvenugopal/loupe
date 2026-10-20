
module TopModule (
    input wire clk,
    input wire a,
    output reg p,
    output reg q
);

    
    always @(posedge clk) begin
        if (a == 0) begin
            p <= 0;
            q <= 0;
        end
    end

    
    always @(posedge clk) begin
        if (a == 1) begin
            p <= ~p;
            q <= ~q;
        end
    end

endmodule
