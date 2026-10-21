
module TopModule (
    input  [7:0] in,
    output [7:0] out
);

    always @(*) begin
        for (int i = 0;
 i < 8;
 i++) begin
            if (i == 0) begin
                out[i] = in[7];
            end else if (i == 1) begin
                out[i] = in[6];
            end else if (i == 2) begin
                out[i] = in[5];
            end else if (i == 3) begin
                out[i] = in[4];
            end else if (i == 4) begin
                out[i] = in[3];
            end else if (i == 5) begin
                out[i] = in[2];
            end else if (i == 6) begin
                out[i] = in[1];
            end else if (i == 7) begin
                out[i] = in[0];
            end
        end
    end

endmodule
