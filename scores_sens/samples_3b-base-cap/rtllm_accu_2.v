
module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg [9:0] data_out,
    output reg valid_out
);

    
    reg [9:0] accu_reg;
    reg [3:0] count;

    
    always @(posedge rst_n or negedge clk) begin
        if (!rst_n) begin
            accu_reg <= 10'b0;
            count <= 4'b0;
            valid_out <= 0;
        end
    end

    
    always @(posedge clk) begin
        if (valid_in) begin
            accu_reg <= accu_reg + data_in;
            count <= count + 1;
        end
    end

    
    always @(posedge clk) begin
        if (count == 4) begin
            data_out <= accu_reg;
            valid_out <= 1;
            count <= 4'b0;
 
        end else begin
            valid_out <= 0;
        end
    end

endmodule
