
module accu (
    input        clk,
    input        rst_n,
    input [7:0]  data_in,
    input        valid_in,
    output reg   valid_out,
    output reg [9:0] data_out
);

    
    reg [7:0] data_reg [3:0];
    reg [9:0] sum;
    reg valid_out_reg;

    integer i;

    always @(posedge clk) begin
        if (!rst_n) begin
            data_reg <= 4'b0;
            sum <= 10'd0;
            valid_out_reg <= 1'b0;
        end else begin
            if (valid_in) begin
                
                data_reg <= {data_reg[2:0], data_in};
                
                sum <= 0;
                for (i = 0;
 i < 4;
 i = i + 1) begin
                    sum <= sum + data_reg[i];
                end
                valid_out_reg <= 1'b1;
            end else begin
                valid_out_reg <= 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
        end else begin
            valid_out <= valid_out_reg;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            data_out <= 10'd0;
        end else begin
            data_out <= sum;
        end
    end

endmodule
