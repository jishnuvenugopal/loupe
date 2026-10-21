
module TopModule (
    input clk,
    input in,
    output out
);

    
    DFlipFlop DFF (
        .clk(clk),
        .d(out),
        .q(out)
    );

    
    assign DFF.d = in;

endmodule


module DFlipFlop (
    input clk,
    input d,
    output q
);

    
    reg [1:0] q_reg;
    always @(posedge clk) begin
        if (d == 1'b1) begin
            q_reg <= d;
        end
    end

    
    assign q = q_reg;

endmodule
