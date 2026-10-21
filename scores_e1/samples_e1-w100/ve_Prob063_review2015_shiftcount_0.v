
module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    
    reg [3:0] shift_reg = 4'b0000;

    always @(posedge clk) begin
        
        if (shift_ena) begin
            shift_reg = {data, shift_reg[3:1]};
        end

        
        if (count_ena) begin
            if (shift_reg == 4'b0000) begin
                q = 4'b1111;
            end else begin
                q = shift_reg - 1;
            end
        end
    end

endmodule
