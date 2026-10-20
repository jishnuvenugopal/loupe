
module TopModule (
    input [99:0] a,
    input [99:0] b,
    input sel,
    output reg [99:0] out
);

always @(*) begin
    reg [99:0] out_temp;
    for (int i = 0;
 i < 100;
 i = i + 1) begin
        if (sel == 0)
            out_temp[i] = a[i];
        else
            out_temp[i] = b[i];
    end
    out = out_temp;
end




endmodule
