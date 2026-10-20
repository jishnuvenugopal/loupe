
module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg valid_lock;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 16'b0;
        valid_out <= 0;
        data_lock <= 8'b0;
        valid_lock <= 0;
    end else begin
        if (valid_in) begin
            if (!valid_lock) begin
                data_lock <= data_in;
                valid_lock <= 1;
            end else begin
                data_out <= {data_lock, data_in};
                valid_out <= 1;
                valid_lock <= 0;
            end
        end
    end
end

endmodule
