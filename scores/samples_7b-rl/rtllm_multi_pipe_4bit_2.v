
module multi_pipe_4bit #(
    parameter size =4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    localparam DATA_WIDTH = 2 * size;
    
    
    wire [DATA_WIDTH-1:0] a_ext = {{size{1'b0}}, mul_a};
    wire [DATA_WIDTH-1:0] b_ext = {{size{1'b0}}, mul_b};
    
    
    wire [DATA_WIDTH-1:0] partial [0:size-1];
    
    generate
        genvar i;
        for (i=0;
 i<size;
 i=i+1) begin : gen_partial
            assign partial[i] = mul_b[i] ? (a_ext << i) : {DATA_WIDTH{1'b0}};
        end
    endgenerate
    
    
    wire [DATA_WIDTH:0] sum_partial;
    assign sum_partial = partial[0] + partial[1] + partial[2] + partial[3];
    
    
    reg [DATA_WIDTH-1:0] sum_stage1, sum_stage2;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1 <= 0;
            sum_stage2 <= 0;
        end else begin
            sum_stage1 <= sum_partial[DATA_WIDTH-1:0];
            sum_stage2 <= sum_stage1;
        end
    end
    
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum_stage2;
        end
    end

endmodule
