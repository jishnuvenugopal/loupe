
module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

    reg [63:0] adda_reg;
    reg [63:0] addb_reg;
    reg [63:0] sum0, sum1, sum2, sum3;
    reg carry0, carry1, carry2, carry3;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg <= 64'b0;
            addb_reg <= 64'b0;
            sum0 <= 64'b0;
            sum1 <= 64'b0;
            sum2 <= 64'b0;
            sum3 <= 64'b0;
            carry0 <= 1'b0;
            carry1 <= 1'b0;
            carry2 <= 1'b0;
            carry3 <= 1'b0;
        end else if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
    end

    
    assign sum0 = adda_reg[0] + addb_reg[0];
    assign carry0 = sum0[64];

    
    assign sum1 = sum0[63:1] + adda_reg[1] + carry0;
    assign carry1 = sum1[64];

    
    assign sum2 = sum1[63:1] + adda_reg[2] + carry1;
    assign carry2 = sum2[64];

    
    assign sum3 = sum2[63:1] + adda_reg[3] + carry2;
    assign carry3 = sum3[64];

    
    assign result = {carry3, sum3, sum2[63:0]};

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en <= 1'b0;
        end else begin
            o_en <= i_en;
        end
    end

endmodule
