
module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

reg [3:0] data;
reg [2:0] cnt;

always @(posedge clk or posedge rst_n) begin
    if (rst_n == 1'b0) begin
        data <= 4'b0000;
        cnt <= 3'b000;
        valid_out <= 1'b0;
    end else begin
        if (cnt == 3'b000) begin
            data <= d;
            cnt <= 3'b001;
            valid_out <= 1'b1;
        end else begin
            data <= {data[2:0], data[3]};
            cnt <= cnt + 1'b1;
            valid_out <= 1'b0;
        end
    end
end

endmodule
