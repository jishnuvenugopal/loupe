
module TopModule (
    input  clk,
    input  load,
    input  [9:0] data, 
    output reg tc     
);

    
    reg [9:0] counter;

    
    reg tc_reg;

    
    always @(posedge clk) begin
        if (load) begin
            
            counter <= data;
            
            tc_reg <= 0;
        end else begin
            
            counter <= counter - 1;
            
            if (counter == 0) begin
                tc_reg <= 1;
            end
        end
    end

    
    assign tc = tc_reg;

endmodule
