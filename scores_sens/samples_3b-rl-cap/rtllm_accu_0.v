
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
            valid_out <= 1'b0;
            data_out <= 10'd0;
        end else begin
            if (valid_in) begin
                
                for (i = 3;
 i >= 1;
 i = i - 1) begin
                    data_reg[i] <= data_reg[i-1];
                end
                data_reg[0] <= data_in;
                
                if (i == 0) begin
                    
                    sum = data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                    data_out <= sum;
                    valid_out <= 1'b1;
                    
                    for (i = 3;
 i >= 0;
 i = i - 1) begin
                        data_reg[i] <= 8'd0;
                    end
                end
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule
