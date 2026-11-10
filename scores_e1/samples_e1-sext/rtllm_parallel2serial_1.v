
module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

reg [3:0] data;
reg [2:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 4'b0;
        cnt <= 3'b0;
        valid_out <= 0;
    end else begin
        if (cnt == 3'b0) begin
            data <= d;
            cnt <= 3'b0;
            valid_out <= 1;
        end else begin
            data <= data << 1;
            data[0] <= d[3];
            cnt <= cnt + 1'b1;
            valid_out <= 0;
        end
    end
end

endmodule
