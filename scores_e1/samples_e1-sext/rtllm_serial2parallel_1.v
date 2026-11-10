
module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_valid,
    input wire [7:0] din_serial,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;
reg [7:0] parallel_data;
reg [7:0] serial_data;
reg [7:0] next_parallel_data;
reg [7:0] next_serial_data;
reg [7:0] next_parallel_data_valid;
reg [7:0] next_serial_data_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        parallel_data <= 8'b0;
        serial_data <= 8'b0;
        next_parallel_data <= 8'b0;
        next_serial_data <= 8'b0;
        next_parallel_data_valid <= 8'b0;
        next_serial_data_valid <= 8'b0;
    end else begin
        if (din_valid) begin
            serial_data <= din_serial;
            cnt <= cnt + 1'b1;
        end else begin
            cnt <= cnt;
        end

        if (cnt == 4'b0) begin
            parallel_data <= next_parallel_data;
            dout_valid <= next_parallel_data_valid;
            cnt <= 4'b0;
        end
    end
end

always @(posedge clk) begin
    if (cnt == 4'b0) begin
        next_parallel_data <= parallel_data;
        next_serial_data <= serial_data;
        next_parallel_data_valid <= dout_valid;
        next_serial_data_valid <= dout_valid;
    end else begin
        next_parallel_data <= parallel_data;
        next_serial_data <= serial_data;
        next_parallel_data_valid <= dout_valid;
        next_serial_data_valid <= dout_valid;
    end
end

endmodule
