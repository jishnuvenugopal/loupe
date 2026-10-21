
module TopModule (
    input clk,
    input a,
    input b,
    output reg out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    
    assign out_assign = a ^ b;

    
    always @(posedge clk) begin
        out_always_comb <= a ^ b;
    end

    
    reg [1:0] q;
    always @(posedge clk) begin
        q <= {q[0], a ^ b};
        out_always_ff <= q[1];
    end

endmodule
