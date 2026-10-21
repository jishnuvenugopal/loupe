
module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;
reg [7:0] data;
reg [7:0] output_data;
reg [7:0] output_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        data <= 8'b0;
        output_data <= 8'b0;
        output_valid <= 0;
    end else begin
        if (din_valid) begin
            data <= data << 1 | din_serial;
            cnt <= cnt + 1;
            if (cnt == 8) begin
                output_data <= data;
                output_valid <= 1;
                cnt <= 4'b0;
                data <= 8'b0;
            end
        end else begin
            output_valid <= 0;
        end
    end
end

assign dout_parallel = output_data;
assign dout_valid = output_valid;

endmodule
