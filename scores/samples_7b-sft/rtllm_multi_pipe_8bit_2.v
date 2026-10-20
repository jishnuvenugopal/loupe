
module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg [2:0] mul_en_out_reg;

wire [15:0] temp [0:7];
integer i;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_out_reg <= 3'b0;
    end else begin
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        mul_en_out_reg <= {mul_en_out_reg[1:0], mul_en_in};
    end
end

assign mul_en_out = mul_en_out_reg[2];


generate
genvar j;
for (j=0;
 j<8;
 j=j+1) begin : gen_partial
    assign temp[j] = ( {8{mul_b_reg[j]}} & mul_a_reg ) << j;
end
endgenerate


reg [15:0] sum [0:6];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum[0] <= 16'b0;
        sum[1] <= 16'b0;
        sum[2] <= 16'b0;
        sum[3] <= 16'b0;
        sum[4] <= 16'b0;
        sum[5] <= 16'b0;
        sum[6] <= 16'b0;
    end else begin
        
        sum[0] <= temp[0] + temp[1];
        sum[1] <= temp[2] + temp[3];
        sum[2] <= temp[4] + temp[5];
        sum[3] <= temp[6] + temp[7];
        
        sum[4] <= sum[0] + sum[1];
        sum[5] <= sum[2] + sum[3];
        
        sum[6] <= sum[4] + sum[5];
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        mul_out_reg <= sum[6];
    end
end


assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule
