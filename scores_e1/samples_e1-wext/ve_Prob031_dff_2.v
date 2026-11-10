
module TopModule (
    input clk,
    input d,
    input q
);

    
    reg q_bar;
    reg q;

    
    always @(posedge clk) begin
        q_bar <= q;
        q <= d;
    end

endmodule
