
module TopModule (
    input d,
    input ena,
    output reg q
);

    
    input clk;

    always @(posedge clk) begin
        if (ena)
            q <= d;
    end

endmodule
