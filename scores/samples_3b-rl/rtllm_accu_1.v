
module accu (
    input        clk,
    input        rst_n,
    input [7:0]  data_in,
    input        valid_in,
    output reg   valid_out,
    output reg [9:0] data_out
);

    
    reg [7:0] data_in_reg [3:0];
    integer i;

    
    reg [9:0] data_out_reg;

    
    reg [3:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out_reg <= 10'd0;
            valid_out <= 1'b0;
            count <= 4'd0;
            data_in_reg <= 4'b0;
        end else begin
            if (valid_in) begin
                
                data_in_reg[count] <= data_in;
                count <= count + 1'b1;

                
                if (count == 4'd4) begin
                    data_out_reg <= data_in_reg[0] + data_in_reg[1] + data_in_reg[2] + data_in_reg[3];
                    valid_out <= 1'b1;
                    count <= 4'd0;
                end else begin
                    valid_out <= 1'b0;
                end
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'd0;
        end else begin
            data_out <= data_out_reg;
        end
    end

endmodule
