
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

    always @(*) begin
        for (integer i = 0;
 i < 16;
 i = i + 1) begin
            for (integer j = 0;
 j < 16;
 j = j + 1) begin
                integer n0, n1, n2, n3, n4, n5, n6, n7;
                integer sum;
                n0 = ((i - 1 + 16) % 16) * 16 + ((j - 1 + 16) % 16);
                n1 = ((i - 1 + 16) % 16) * 16 + j;
                n2 = ((i - 1 + 16) % 16) * 16 + ((j + 1) % 16);
                n3 = i * 16 + ((j - 1 + 16) % 16);
                n4 = i * 16 + ((j + 1) % 16);
                n5 = ((i + 1) % 16) * 16 + ((j - 1 + 16) % 16);
                n6 = ((i + 1) % 16) * 16 + j;
                n7 = ((i + 1) % 16) * 16 + ((j + 1) % 16);
                sum = q[n0] + q[n1] + q[n2] + q[n3] + q[n4] + q[n5] + q[n6] + q[n7];
                next_q[i * 16 + j] = (sum == 0 || sum == 1) ? 1'b0 :
                                     (sum == 2) ? q[i * 16 + j] :
                                     (sum == 3) ? 1'b1 : 1'b0;
            end
        end
    end

endmodule
