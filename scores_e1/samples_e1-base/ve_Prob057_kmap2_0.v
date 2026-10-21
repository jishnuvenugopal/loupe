
module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output reg out
);

    reg [3:0] input_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            input_reg <= 4'b0;
            out <= 1'b0;
        end else begin
            input_reg <= {a, b, c, d};
            out <= (input_reg == 4'b0000 || input_reg == 4'b0001 || input_reg == 4'b0111 || input_reg == 4'b0101);
        end
    end

endmodule
