
module TopModule (
    input wire [7:0] in,  
    output reg [8:0] parity  
);

    
    reg [7:0] parity_bits = in;

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            parity_bits = 8'b0;
        end else begin
            parity_bits = parity_bits ^ in;
        end
    end

    
    assign parity = {parity_bits, 1'b0};
  

endmodule
