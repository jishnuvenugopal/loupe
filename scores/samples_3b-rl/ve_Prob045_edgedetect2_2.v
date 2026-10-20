
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge,
    output reg [7:0] out
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;
    end

    always @(*) begin
        out = 8'b0;
        for (int i = 0;
 i < 8;
 i = i + 1) begin
            if (anyedge[i] && (prev_in[i] == 1'b0) && (in[i] == 1'b1))
                out[i] = 1'b1;
        end
    end

endmodule
