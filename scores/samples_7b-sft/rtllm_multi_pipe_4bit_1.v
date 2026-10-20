
module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    parameter size = 4;

    wire [7:0] extended_mul_a = {4'b0, mul_a};
    wire [7:0] extended_mul_b = {4'b0, mul_b};

    wire [7:0] partial_products [0:3];
    generate
        genvar i;
        for (i=0;
 i<4;
 i=i+1) begin : pp_gen
            assign partial_products[i] = extended_mul_b[i] ? (extended_mul_a << i) : 8'd0;
        end
    endgenerate

    reg [7:0] pp_reg0, pp_reg1, pp_reg2, pp_reg3;
    reg [7:0] sum_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp_reg0 <= 8'd0;
            pp_reg1 <= 8'd0;
            pp_reg2 <= 8'd0;
            pp_reg3 <= 8'd0;
            sum_reg <= 8'd0;
            mul_out <= 8'd0;
        end else begin
            pp_reg0 <= partial_products[0];
            pp_reg1 <= partial_products[1];
            pp_reg2 <= partial_products[2];
            pp_reg3 <= partial_products[3];
            sum_reg <= pp_reg0 + pp_reg1 + pp_reg2 + pp_reg3;
            mul_out <= sum_reg;
        end
    end

endmodule
