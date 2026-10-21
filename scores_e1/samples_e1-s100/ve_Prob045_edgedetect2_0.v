
module TopModule (
    input clk,
    input in,
    input anyedge
);

    
    reg [7:0] prev_in;
    reg [7:0] current_in;

    
    always @(posedge clk) begin
        
        current_in <= in;

        
        if (current_in != prev_in) begin
            
            anyedge <= 1'b1;
        end else begin
            
            anyedge <= 1'b0;
        end

        
        prev_in <= current_in;
    end

endmodule
