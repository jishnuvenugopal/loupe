
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

    
    reg [3:0] input_reg;

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            input_reg <= 4'b0000;
            out <= 1'b0;
        end else begin
            input_reg <= {a, b, c, d};
            out <= input_reg[3];
 
        end
    end

endmodule
