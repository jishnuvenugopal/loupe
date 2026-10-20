
module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output dout
);

reg [3:0] data_reg;
reg [1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_reg <= 4'b0;
        cnt <= 2'b0;
        valid_out <= 1'b0;
    end else begin
        if (cnt == 2'b11) begin
            data_reg <= d;
            cnt <= 2'b00;
            valid_out <= 1'b1;
        end else begin
            data_reg <= {data_reg[2:0], 1'b0};
            cnt <= cnt + 1;
            valid_out <= 1'b0;
        end
    end
end

assign dout = data_reg[3];

endmodule
