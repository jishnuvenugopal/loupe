
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge,
    output [7:0] out
);

    reg [7:0] prev_in;
    reg [7:0] out;

    integer i;

    always @(posedge clk) begin
        
        for (i = 0;
 i < 8;
 i = i + 1) begin
            if (in[i] && !prev_in[i])
                out[i] <= 1;
            else
                out[i] <= 0;
        end
        prev_in <= in;
    end

endmodule
