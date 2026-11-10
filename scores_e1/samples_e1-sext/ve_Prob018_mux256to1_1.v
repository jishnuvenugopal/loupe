
module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output reg   out
);

always @(*) begin
    for (int i = 0;
 i < 8;
 i = i + 1) begin
        if (sel == i) begin
            out = in[i];
            break;
        end
    end
end

endmodule
