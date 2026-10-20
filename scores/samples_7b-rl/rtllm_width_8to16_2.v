
module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] stored_byte;
reg has_stored;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stored_byte <= 8'd0;
        has_stored <= 1'b0;
        data_out <= 16'd0;
        valid_out <= 1'b0;
    end
    else begin
        valid_out <= 1'b0;
 
        
        if (has_stored) begin
            if (valid_in) begin
                data_out <= {stored_byte, data_in};
                valid_out <= 1'b1;
                has_stored <= 1'b0;
            end
        end
        else begin
            if (valid_in) begin
                stored_byte <= data_in;
                has_stored <= 1'b1;
            end
        end
    end
end

endmodule
