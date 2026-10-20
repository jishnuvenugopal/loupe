
module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] data;
reg [1:0] cnt;
reg valid;

assign dout = data[3];
assign valid_out = valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 2'd0;
        data <= 4'd0;
        valid <= 1'd0;
    end else begin
        if (cnt == 2'd3) begin
            data <= d;
            cnt <= 2'd0;
            valid <= 1'd1;
        end else begin
            cnt <= cnt + 1;
            data <= {data[2:0], data[3]};
 
            valid <= 1'd0;
        end
    end
end

endmodule
