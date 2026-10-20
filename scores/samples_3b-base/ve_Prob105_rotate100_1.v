
module TopModule (
    input  clk,
    input  load,
    input  [1:0] ena,
    input  [99:0] data,
    output reg [99:0] q
);

    
    reg [99:0] reg_q;

    
    always @(posedge clk) begin
        if (load) begin
            
            reg_q <= data;
        end else if (ena[1] && ena[0]) begin
            
            reg_q <= {reg_q[98:0], reg_q[99]};
        end else if (ena[1]) begin
            
            reg_q <= {reg_q[0], reg_q[99:1]};
        end
    end

    
    assign q = reg_q;

endmodule
