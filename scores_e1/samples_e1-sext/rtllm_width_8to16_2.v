
module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg [15:0] data_out,
    output reg valid_out
);

reg [7:0] data_lock;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'b0;
        valid_out <= 1'b0;
    end else begin
        if (valid_in) begin
            if (data_lock == 8'b0) begin
                data_lock <= data_in;
                valid_out <= 1'b1;
            end else begin
                data_lock <= {data_lock[7:0], data_in[7:0]};
                valid_out <= 1'b1;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule
