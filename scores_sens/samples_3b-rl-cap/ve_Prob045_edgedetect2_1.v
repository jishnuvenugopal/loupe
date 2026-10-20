
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge,
    output [7:0] out
);

    reg [7:0] prev_in;
    reg [7:0] prev_prev_in;

    always @(posedge clk) begin
        prev_prev_in <= prev_in;
        prev_in <= in;
    end

    reg [7:0] out_reg;

    always @(posedge clk) begin
        out_reg <= 8'b0;
        for (integer i = 0;
 i < 8;
 i = i + 1) begin
            if (anyedge[i]) begin
                if (prev_prev_in[i] == 1'b0 && prev_in[i] == 1'b1)
                    out_reg[i] <= 1'b1;
            end
        end
    end

    assign out = out_reg;

endmodule
