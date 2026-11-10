
module TopModule (
    input wire clk,
    input wire a,
    output reg q
);

    
    reg q_prev;

    
    always @(posedge clk) begin
        q_prev = q;
        q = a ^ q_prev;
    end

endmodule
