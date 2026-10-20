
module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    
    reg [7:0] data_lock;

    
    reg first_valid_received;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
            data_out <= 16'h0;
            valid_out <= 1'b0;
            
            data_lock <= 8'h0;
            
            first_valid_received <= 1'b0;
        end else begin
            
            if (!first_valid_received && valid_in) begin
                
                data_lock <= data_in;
                
                first_valid_received <= 1'b1;
            end else if (valid_in) begin
                
                data_out <= {data_lock, data_in};
                
                valid_out <= 1'b1;
            end else begin
                
                valid_out <= 1'b0;
            end
        end
    end

endmodule
