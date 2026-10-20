
module accu (
    input        clk,
    input        rst_n,
    input [7:0]  data_in,
    input        valid_in,
    output reg   valid_out,
    output reg [9:0] data_out
);

    
    reg [7:0] data_in_reg [3:0];
    reg [9:0] data_out_reg;
    reg       valid_out_reg;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_reg <= 4'b0;
            data_out_reg <= 10'd0;
            valid_out_reg <= 1'b0;
        end else begin
            if (valid_in) begin
                
                data_in_reg[3] <= data_in_reg[2];
                data_in_reg[2] <= data_in_reg[1];
                data_in_reg[1] <= data_in_reg[0];
                data_in_reg[0] <= data_in;

                
                data_out_reg <= 0;
                for (i = 0;
 i < 4;
 i = i + 1) begin
                    data_out_reg <= data_out_reg + data_in_reg[i];
                end
                valid_out_reg <= 1'b1;
            end else begin
                valid_out_reg <= 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (valid_out_reg) begin
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (valid_out_reg) begin
            data_out <= data_out_reg;
        end else begin
            data_out <= 10'd0;
        end
    end

endmodule
