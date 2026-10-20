
module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg [9:0] data_out,
    output reg valid_out
);

reg [7:0] data_reg [0:3];
 
reg [9:0] sum;
 
reg [1:0] count;
 

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_reg <= {4{8'b0}};
 
        sum <= 10'b0;
 
        count <= 2'b0;
 
        valid_out <= 1'b0;
 
    end else begin
        if (valid_in) begin
            data_reg[count] <= data_in;
 
            sum <= sum + data_in;
 
            count <= count + 1'b1;
 
        end
        
        if (count == 2'b11) begin 
            data_out <= sum;
 
            valid_out <= 1'b1;
 
            count <= 2'b0;
 
            sum <= 10'b0;
 
        end else begin
            valid_out <= 1'b0;
 
        end
    end
end

endmodule
