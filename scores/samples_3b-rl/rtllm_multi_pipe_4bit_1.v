
module multi_pipe_4bit (
    input        clk,
    input        rst_n,
    input  [3:0] mul_a,
    input  [3:0] mul_b,
    output reg [7:0] mul_out
);

    parameter size = 4;

    
    wire [4:0] mul_a_ext, mul_b_ext;
    assign mul_a_ext = {1'b0, mul_a};
    assign mul_b_ext = {1'b0, mul_b};

    
    reg [7:0] sum1, sum2;

    
    generate
        genvar i;
        for (i = 0;
 i < size;
 i = i + 1) begin : gen_loop
            
            
            assign sum1 = (mul_b_ext[i] ? mul_a_ext << i : 5'b0) + sum1;
            
            
            assign sum2 = (mul_b_ext[i + size] ? mul_a_ext << i : 5'b0) + sum2;
        end
    endgenerate

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1  <= 8'b0;
            sum2  <= 8'b0;
            mul_out <= 8'b0;
        end else begin
            sum1  <= sum1;
            sum2  <= sum2;
            mul_out <= sum1 + sum2;
        end
    end

endmodule
