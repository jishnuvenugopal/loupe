
module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [9:0] sum;
reg [2:0] count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 10'b0;
        count <= 3'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end else begin
        if (valid_in && count < 3'b100) begin
            sum <= sum + data_in;
            count <= count + 1;
        end
        if (count == 3'b100) begin
            valid_out <= 1'b1;
            data_out <= sum;
        end else begin
            valid_out <= 1'b0;
        end
        if (valid_out) begin
            sum <= 10'b0;
            count <= 3'b0;
        end
    end
end

endmodule
