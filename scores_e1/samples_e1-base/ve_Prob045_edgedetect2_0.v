
module TopModule (
    input clk,
    input in      (8 bits),
    input anyedge (8 bits),
    output reg output
);

    reg [7:0] reg;
    reg [7:0] reg_prev;
    reg [7:0] reg_output;

    always @(posedge clk) begin
        reg_prev <= reg;
        reg <= in;

        if (reg != reg_prev) begin
            reg_output <= 1'b1;
        end else begin
            reg_output <= 1'b0;
        end
    end

    assign output = reg_output;

endmodule
