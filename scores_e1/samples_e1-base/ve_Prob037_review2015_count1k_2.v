
module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    
    reg [9:0] counter;

    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 10'b0;
 
        end else begin
            counter <= counter + 1'b1;
 
        end
    end

    
    assign q = counter;

endmodule
