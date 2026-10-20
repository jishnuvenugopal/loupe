
module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] shift_reg;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            cnt <= 2'd0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                
                shift_reg <= d;
                cnt <= 2'd0;
                valid_out <= 1'b1;
                dout <= d[3];
            end else begin
                
                dout <= shift_reg[3];
                shift_reg <= shift_reg << 1;
                cnt <= cnt + 1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule
