
module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [3:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 4'b0000;
            start_shifting <= 1'b0;
        end else begin
            data_reg <= {data_reg[2:0], data};
            if (data_reg == 4'b1101) begin
                start_shifting <= 1'b1;
            end
        end
    end

endmodule
