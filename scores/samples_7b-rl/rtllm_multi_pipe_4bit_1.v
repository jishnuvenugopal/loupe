
module multi_pipe_4bit #(
    parameter size =4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

localparam TWO_SIZE = 2 * size;


wire [TWO_SIZE-1 :0] a_ext, b_ext;
assign a_ext = {{size{1'b0}}, mul_a};
assign b_ext = {{size{1'b0}}, mul_b};


wire [TWO_SIZE-1:0] pp [0:size-1];

genvar i;
generate
for (i=0;
 i<size;
 i=i+1) begin : gen_partial
    assign pp[i] = b_ext[i] ? (a_ext << i) : {TWO_SIZE{1'b0}};
end
endgenerate


reg [TWO_SIZE-1 :0] sum_comb;

integer j;
always @* begin
    sum_comb = 0;
    for (j=0;
 j<size;
 j=j+1) begin
        sum_comb = sum_comb + pp[j];
    end
end


reg [TWO_SIZE-1 :0] stage1, stage2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1 <= 0;
        stage2 <= 0;
    end
    else begin
        stage1 <= sum_comb;
        stage2 <= stage1;
    end
end


assign mul_out = stage2;

endmodule
