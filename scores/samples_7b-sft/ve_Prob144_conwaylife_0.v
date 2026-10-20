
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

wire [3:0] neighbor_count [0:255];
wire [255:0] next_q;

generate
genvar i, j;
for (i = 0;
 i < 16;
 i = i + 1) begin : row_loop
    for (j = 0;
 j < 16;
 j = j + 1) begin : col_loop
        
        wire [3:0] n0_row = (i == 0) ? 15 : (i - 1);
        wire [3:0] n0_col = (j == 0) ? 15 : (j - 1);
        wire [3:0] n0_idx = n0_row * 16 + n0_col;

        wire [3:0] n1_row = (i == 0) ? 15 : (i - 1);
        wire [3:0] n1_col = j;
        wire [3:0] n1_idx = n1_row * 16 + n1_col;

        wire [3:0] n2_row = (i == 0) ? 15 : (i - 1);
        wire [3:0] n2_col = (j == 15) ? 0 : (j + 1);
        wire [3:0] n2_idx = n2_row * 16 + n2_col;

        wire [3:0] n3_row = i;
        wire [3:0] n3_col = (j == 0) ? 15 : (j - 1);
        wire [3:0] n3_idx = n3_row * 16 + n3_col;

        wire [3:0] n4_row = i;
        wire [3:0] n4_col = (j == 15) ? 0 : (j + 1);
        wire [3:0] n4_idx = n4_row * 16 + n4_col;

        wire [3:0] n5_row = (i == 15) ? 0 : (i + 1);
        wire [3:0] n5_col = (j == 0) ? 15 : (j - 1);
        wire [3:0] n5_idx = n5_row * 16 + n5_col;

        wire [3:0] n6_row = (i == 15) ? 0 : (i + 1);
        wire [3:0] n6_col = j;
        wire [3:0] n6_idx = n6_row * 16 + n6_col;

        wire [3:0] n7_row = (i == 15) ? 0 : (i + 1);
        wire [3:0] n7_col = (j == 15) ? 0 : (j + 1);
        wire [3:0] n7_idx = n7_row * 16 + n7_col;

        
        assign neighbor_count[i*16 + j] = 
            q[n0_idx] + q[n1_idx] + q[n2_idx] + q[n3_idx] +
            q[n4_idx] + q[n5_idx] + q[n6_idx] + q[n7_idx];

        
        assign next_q[i*16 + j] = (neighbor_count[i*16 + j] == 3) ? 1'b1 :
                                   (neighbor_count[i*16 + j] <= 1) ? 1'b0 :
                                   (neighbor_count[i*16 + j] == 2) ? q[i*16 + j] : 1'b0;
    end
end
endgenerate


always @(posedge clk) begin
    if (load)
        q <= data;
    else
        q <= next_q;
end

endmodule
