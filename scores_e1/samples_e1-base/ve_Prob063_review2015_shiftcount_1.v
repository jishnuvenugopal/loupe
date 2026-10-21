
module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    
    reg [3:0] reg_value = 4'b0000;

    always @(posedge clk) begin
        
        if (shift_ena) begin
            reg_value <= {reg_value[2:0], data};
        end

        
        if (count_ena) begin
            reg_value <= reg_value - 1'b1;
        end

        
        q <= reg_value;
    end

endmodule
