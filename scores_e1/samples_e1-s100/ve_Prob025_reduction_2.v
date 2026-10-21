
module TopModule (
    input  [7:0] in,  
    output reg parity  
);

    
    wire [0:0] parity_bit;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            parity_bit <= 0;
 
        end else begin
            parity_bit <= in ^ parity_bit;
 
        end
    end

    
    assign parity = parity_bit;

endmodule
