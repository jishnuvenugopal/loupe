
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
reg [64:0] sum1;
reg [64:0] sum2;
reg [64:0] sum3;
reg [64:0] sum4;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'b0;
        addb_reg <= 64'b0;
        sum1 <= 64'b0;
        sum2 <= 64'b0;
        sum3 <= 64'b0;
        sum4 <= 64'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end

        sum1 <= adda_reg + {1'b0, addb_reg};
        sum2 <= sum1 + {1'b0, sum1[63]};
        sum3 <= sum2 + {1'b0, sum2[63]};
        sum4 <= sum3 + {1'b0, sum3[63]};

        result <= sum4;
        o_en <= i_en & ~rst_n;
    end
end

endmodule
