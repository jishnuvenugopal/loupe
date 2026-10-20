
module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg has_first_data;
reg [7:0] stored_data;
reg output_pending;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'b0;
        has_first_data <= 1'b0;
        stored_data <= 8'b0;
        output_pending <= 1'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        valid_out <= 1'b0;

        
        if (output_pending) begin
            data_out <= {data_lock, stored_data};
            valid_out <= 1'b1;
            output_pending <= 1'b0;
        end

        
        if (has_first_data && valid_in) begin
            stored_data <= data_in;
            output_pending <= 1'b1;
            has_first_data <= 1'b0;
        end else if (valid_in) begin
            data_lock <= data_in;
            has_first_data <= 1'b1;
        end
    end
end

endmodule
