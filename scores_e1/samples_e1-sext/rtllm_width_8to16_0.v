
module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg [7:0] data_out_reg;
reg [1:0] flag;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'b0;
        data_out_reg <= 16'b0;
        flag <= 2'b0;
        valid_out <= 1'b0;
    end else begin
        if (valid_in) begin
            if (flag == 2'b0) begin
                data_lock <= data_in;
                flag <= 2'b1;
            end else begin
                data_out_reg <= {data_lock, data_in};
                valid_out <= 1'b1;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end
end

assign data_out = data_out_reg;

endmodule
