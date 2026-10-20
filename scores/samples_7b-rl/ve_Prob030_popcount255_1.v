
module TopModule (
    input [254:0] in,
    output [7:0] out
);
    reg [7:0] popcount;
    integer i;

    always @* begin
        popcount = 0;
        for (i = 0;
 i < 255;
 i = i + 1) begin
            popcount = popcount + in[i];
        end
    end

    assign out = popcount;
endmodule
