
module TopModule (
    input  clk,
    input  shift_ena,
    input  count_ena,
    input  data,
    output reg [3:0] q
);

    
    reg [3:0] shift_reg;

    
    always @(posedge clk) begin
        if (shift_ena) begin
            
            shift_reg[3] <= data;
            for (int i = 2;
 i >= 0;
 i--) begin
                shift_reg[i] <= shift_reg[i + 1];
            end
        end
    end

    
    reg [3:0] count_reg;
    always @(posedge clk) begin
        if (count_ena) begin
            
            count_reg <= count_reg - 1;
        end
    end

    
    always @(posedge clk) begin
        if (count_ena) begin
            
            q <= count_reg;
        end else begin
            
            q <= shift_reg;
        end
    end

endmodule
