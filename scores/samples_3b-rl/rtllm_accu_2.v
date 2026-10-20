
module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [7:0] data_reg [3:0];
    reg [9:0] data_sum_reg;
    reg [9:0] data_sum;
    integer i;

    always @(posedge clk) begin
        if (!rst_n) begin
            data_reg <= 4'b0;
            data_sum_reg <= 10'd0;
            valid_out <= 1'b0;
            data_out <= 10'd0;
        end else begin
            if (valid_in) begin
                
                data_reg <= {data_reg[2:0], data_in};
                
                data_sum_reg <= data_sum_reg + data_in;
            end
            
            if (data_reg == 4'b1111) begin
                data_sum <= data_sum_reg;
                valid_out <= 1'b1;
                data_out <= data_sum;
                
                data_reg <= 4'b0;
                data_sum_reg <= 10'd0;
                valid_out <= 1'b0;
                data_out <= 10'd0;
            end else begin
                valid_out <= 1'b0;
                data_out <= 10'd0;
            end
        end
    end

endmodule
