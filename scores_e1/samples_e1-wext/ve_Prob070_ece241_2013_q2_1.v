
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out_sop,
    output reg out_pos
);

    
    reg [3:0] input_reg;

    
    always @(posedge clk) begin
        input_reg <= {a, b, c, d};
    end

    
    always @(posedge clk) begin
        if (input_reg == 4'b0000) begin
            out_sop <= 1'b0;
            out_pos <= 1'b0;
        end else if (input_reg == 4'b0011) begin
            out_sop <= 1'b1;
            out_pos <= 1'b0;
        end else if (input_reg == 4'b0101) begin
            out_sop <= 1'b1;
            out_pos <= 1'b0;
        end else if (input_reg == 4'b0110) begin
            out_sop <= 1'b1;
            out_pos <= 1'b0;
        end else if (input_reg == 4'b1000) begin
            out_sop <= 1'b0;
            out_pos <= 1'b1;
        end else if (input_reg == 4'b1011) begin
            out_sop <= 1'b1;
            out_pos <= 1'b1;
        end else if (input_reg == 4'b1101) begin
            out_sop <= 1'b1;
            out_pos <= 1'b1;
        end else if (input_reg == 4'b1110) begin
            out_sop <= 1'b1;
            out_pos <= 1'b1;
        end else if (input_reg == 4'b1111) begin
            out_sop <= 1'b0;
            out_pos <= 1'b1;
        end
    end

endmodule
