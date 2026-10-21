
module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    
    reg [99:0] reg;

    
    always @(posedge clk or posedge load) begin
        if (load) begin
            reg <= data;
        end
    end

    
    always @(posedge clk) begin
        if (ena[1]) begin
            reg <= {reg[99], reg[98:0]};
        end else if (ena[0]) begin
            reg <= {reg[1:99], reg[0]};
        end
    end

    
    assign q = reg;

endmodule
