
module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output wire valid_out,
    output wire [15:0] data_out
);

    reg [7:0] data_lock;
 
    reg [15:0] data_out;
 
    reg valid_out_reg;
 
    reg flag;
 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
 
            valid_out_reg <= 0;
 
            data_lock <= 0;
 
            flag <= 0;
 
        end else begin
            if (valid_in) begin
                if (!flag) begin
                    data_lock <= data_in;
 
                    flag <= 1;
 
                end else begin
                    data_out <= {data_lock, data_in};
 
                    valid_out_reg <= 1;
 
                    flag <= 0;
 
                end
            end else begin
                data_out <= data_out;
 
                valid_out_reg <= valid_out_reg;
 
            end
        end
    end

    assign valid_out = valid_out_reg;
 

endmodule
