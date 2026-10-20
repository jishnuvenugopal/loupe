
module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output wire out_always_ff
);

    
    assign out_assign = a ^ b;

    
    reg out_always_comb;
    always @ (posedge clk) begin
        out_always_comb <= a ^ b;
    end

    
    reg out_always_ff;
    always @ (posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
