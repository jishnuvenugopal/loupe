
module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg [15:0] data_out_reg;
    reg [1:0] data_in_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock <= 8'b0;
            data_out_reg <= 16'b0;
            data_in_count <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (valid_in && data_in_count == 0) begin
                data_lock <= data_in;
                data_in_count <= 2'b1;
            end else if (valid_in && data_in_count == 1) begin
                data_out_reg <= {data_lock, data_in};
                valid_out <= 1'b1;
                data_in_count <= 2'b0;
            end
        end
    end

endmodule
