
module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    
    reg [3:0] shift_reg;

    
    reg [3:0] counter;

    
    always @(posedge clk) begin
        if (shift_ena) begin
            
            shift_reg <= {data, shift_reg[2:0]};
        end

        if (count_ena) begin
            
            counter <= counter - 1;
        end

        
        q <= shift_reg;
    end

endmodule
