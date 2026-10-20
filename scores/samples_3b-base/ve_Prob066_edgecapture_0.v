
module TopModule (
    input  clk,
    input  reset,
    input  [31:0] in,
    output [31:0] out
);

    
    reg [31:0] captured_value;

    
    
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            captured_value <= 0;
 
        end else begin
            
            
            if (in != captured_value) begin
                captured_value <= in;
 
            end
        end
    end

    
    assign out = captured_value;

endmodule
