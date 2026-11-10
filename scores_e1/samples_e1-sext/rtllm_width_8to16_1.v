
module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg [7:0] data_in_temp;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'b0;
        data_in_temp <= 8'b0;
        valid_out <= 0;
        data_out <= 16'b0;
    end else begin
        if (valid_in && data_lock == 8'b0) begin
            data_lock <= data_in;
            valid_out <= 1;
            data_out <= {data_lock, data_in};
        end else if (valid_in && data_lock != 8'b0) begin
            data_in_temp <= data_in;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'b0;
        data_in_temp <= 8'b0;
        valid_out <= 0;
        data_out <= 16'b0;
    end else begin
        if (valid_in && data_lock == 8'b0) begin
            data_lock <= data_in;
            valid_out <= 1;
            data_out <= {data_lock, data_in};
        end else if (valid_in && data_lock != 8'b0) begin
            data_in_temp <= data_in;
        end
    end
end

endmodule
