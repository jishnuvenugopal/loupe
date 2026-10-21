
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
    reg [7:0] output_data;
    reg [7:0] output_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'b0;
            serial_data <= 8'b0;
            parallel_data <= 8'b0;
            output_data <= 8'b0;
            output_valid <= 0;
        end else begin
            if (din_valid) begin
                serial_data <= serial_data << 1;
                serial_data[0] <= din_serial;
                cnt <= cnt + 1;
            end else if (cnt == 8) begin
                output_data <= serial_data;
                output_valid <= 1;
                cnt <= 0;
            end
        end
    end

    assign dout_parallel = output_data;
    assign dout_valid = output_valid;

endmodule
