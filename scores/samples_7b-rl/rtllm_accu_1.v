
module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [9:0] sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            sum <= 0;
            valid_out <= 0;
            data_out <= 0;
        end else begin
            valid_out <= 0;
 
            if (valid_in) begin
                if (count == 2'd3) begin 
                    data_out <= sum + data_in;
                    valid_out <= 1;
                    sum <= 0;
                    count <= 0;
                end else begin
                    sum <= sum + data_in;
                    count <= count + 1;
                end
            end
        end
    end

endmodule
