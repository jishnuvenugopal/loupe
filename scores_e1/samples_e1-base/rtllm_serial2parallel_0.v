
module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;
reg [7:0] serial_data;
reg [7:0] parallel_data;
reg [7:0] valid_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        serial_data <= 8'b0;
        parallel_data <= 8'b0;
        valid_data <= 0;
    end else begin
        if (din_valid) begin
            serial_data <= serial_data << 1 | din_serial;
            cnt <= cnt + 1;
            if (cnt == 8) begin
                parallel_data <= serial_data;
                valid_data <= 1;
                cnt <= 4'b0;
                serial_data <= 8'b0;
            end
        end else begin
            valid_data <= 0;
        end
    end
end

assign dout_parallel = parallel_data;
assign dout_valid = valid_data;

endmodule
