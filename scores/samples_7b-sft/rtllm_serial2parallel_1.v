
module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [7:0] shift_reg;
reg [2:0] cnt_reg;
reg output_valid_next;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 8'b0;
        cnt_reg <= 3'b0;
        dout_parallel <= 8'b0;
        dout_valid <= 1'b0;
        output_valid_next <= 1'b0;
    end else begin
        dout_valid <= output_valid_next;
        output_valid_next <= 1'b0;

        if (din_valid) begin
            shift_reg <= {din_serial, shift_reg[7:1]};

            if (cnt_reg == 3'd7) begin
                cnt_reg <= 3'b0;
                output_valid_next <= 1'b1;
                dout_parallel <= {din_serial, shift_reg[7:1]};
            end else begin
                cnt_reg <= cnt_reg + 1;
            end
        end
    end
end

endmodule
