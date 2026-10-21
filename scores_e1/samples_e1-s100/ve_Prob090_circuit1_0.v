
module TopModule (
    input a,
    input b,
    output q
);

    
    reg [4:0] delay;

    
    always @(posedge clk) begin
        delay <= delay + 1;
        if (delay == 5) begin
            q <= a & b;
            delay <= 0;
        end
    end

endmodule
