
module multi_pipe_4bit (
    input        clk,
    input        rst_n,
    input  [3:0] mul_a,
    input  [3:0] mul_b,
    output reg [7:0] mul_out
);

    parameter size = 4;

    
    wire [7:0] mul_a_ext = {4'b0000, mul_a};
    wire [7:0] mul_b_ext = {4'b0000, mul_b};

    
    reg [7:0] sum1;
    reg [7:0] sum2;

    
    generate
        genvar i;
        for (i = 0;
 i < size;
 i = i + 1) begin : gen_mult
            
            
            assign sum1 = (mul_b_ext[i] ? mul_a_ext << i : 8'b0) + sum1;
            
            
            assign sum2 = (mul_b_ext[i] ? mul_a_ext << i : 8'b0) + sum2;
        end
    endgenerate

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1 <= 8'b0;
            sum2 <= 8'b0;
        end else begin
            sum1 <= sum1;
            sum2 <= sum2;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 8'b0;
        end else begin
            mul_out <= sum1 + sum2;
        end
    end

endmodule
