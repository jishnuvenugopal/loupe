
module TopModule(clk, reset, slowena, q);
    input  clk;
    input  reset;
    input  slowena;
    output reg [3:0] q;

    
    reg [3:0] counter_reg;

    always @(posedge clk) begin
        if (reset) begin
            
            counter_reg <= 4'b0000;
        end else begin
            
            if (slowena) begin
                counter_reg <= counter_reg + 1;
            end
            
            if (counter_reg == 4'b1001) begin
                counter_reg <= 4'b0000;
            end
        end
    end

    
    assign q = counter_reg;
endmodule
