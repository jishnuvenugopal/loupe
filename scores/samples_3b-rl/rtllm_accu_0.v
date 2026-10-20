
module accu (
    input        clk,
    input        rst_n,
    input [7:0]  data_in,
    input        valid_in,
    output reg   valid_out,
    output reg [9:0] data_out
);

    
    reg [7:0] data_reg [3:0];

    integer i;
    reg [9:0] sum;

    always @(posedge clk) begin
        if (!rst_n) begin
            
            data_reg <= 4'b0;
            sum <= 10'd0;
            valid_out <= 1'b0;
            data_out <= 10'd0;
        end else begin
            if (valid_in) begin
                
                data_reg <= {data_reg[2:0], data_in};
                
                sum <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
            end else begin
                sum <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
            end

            
            if (data_reg[3] == 1'b1) begin
                
                data_out <= sum;
                valid_out <= 1'b1;
            end else begin
                data_out <= 10'd0;
                valid_out <= 1'b0;
            end
        end
    end

endmodule
