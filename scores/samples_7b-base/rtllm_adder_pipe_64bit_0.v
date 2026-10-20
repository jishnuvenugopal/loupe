
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
    reg [63:0] sum1;
    reg [63:0] sum2;
    reg [63:0] sum3;

    
    reg [63:0] carry1;
    reg [63:0] carry2;
    reg [63:0] carry3;
    reg carry4;

    
    reg e_sum1;
    reg e_sum2;
    reg e_sum3;
    reg e_result;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg <= 64'b0;
            addb_reg <= 64'b0;
            sum1 <= 64'b0;
            sum2 <= 64'b0;
            sum3 <= 64'b0;
            carry1 <= 64'b0;
            carry2 <= 64'b0;
            carry3 <= 64'b0;
            carry4 <= 0;
            e_sum1 <= 0;
            e_sum2 <= 0;
            e_sum3 <= 0;
            e_result <= 0;
        end else begin
            if (i_en) begin
                adda_reg <= adda;
                addb_reg <= addb;
            end

            sum1 <= adda_reg + carry1;
            carry1 <= sum1[64];

            sum2 <= sum1 + carry2;
            carry2 <= sum2[64];

            sum3 <= sum2 + carry3;
            carry3 <= sum3[64];

            carry4 <= sum3[64];

            if (e_sum3) begin
                result <= sum3;
                e_result <= 1;
            end else begin
                e_result <= 0;
            end

            e_sum1 <= 1;
            e_sum2 <= e_sum1;
            e_sum3 <= e_sum2;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en <= 0;
        end else begin
            o_en <= e_result;
        end
    end

endmodule
