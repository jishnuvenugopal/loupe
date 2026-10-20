
module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    reg stored_first;
    reg [7:0] stored_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_first <= 1'b0;
            stored_data <= 8'b0;
            valid_out <= 1'b0;
            data_out <= 16'b0;
        end else begin
            
            valid_out <= 1'b0;

            if (stored_first) begin
                if (valid_in) begin
                    
                    data_out <= {stored_data, data_in};
                    valid_out <= 1'b1;
                    stored_first <= 1'b0;
                end
            end else begin
                if (valid_in) begin
                    
                    stored_data <= data_in;
                    stored_first <= 1'b1;
                end
            end
        end
    end

endmodule
