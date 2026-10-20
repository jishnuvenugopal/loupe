
module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

reg [3:0] data;
reg [1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 0;
        dout <= 0;
        data <= 0;
        cnt <= 0;
    end else begin
        if (cnt == 3) begin
            data <= d;
            cnt <= 0;
            valid_out <= 1;
        end else begin
            dout <= data[0];
            data <= {data[3:1], d[3 - cnt - 1]};
            cnt <= cnt + 1;
            valid_out <= 0;
        end
    end
end

endmodule
