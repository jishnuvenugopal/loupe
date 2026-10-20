
module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [9:0] sum;
reg [1:0] counter;

wire [9:0] next_sum = valid_in ? sum + data_in : sum;
wire [1:0] next_counter = valid_in ? counter + 1 : counter;
wire next_valid_out = valid_in && (counter == 3);
wire [9:0] next_data_out = valid_in && (counter == 3) ? sum + data_in : data_out;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 10'b0;
        counter <= 2'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end else begin
        sum <= next_sum;
        counter <= next_counter;
        valid_out <= next_valid_out;
        if (next_valid_out) begin
            data_out <= next_data_out;
        end
    end
end

endmodule
