
module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    
    reg [99:0] reversed;

    
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            reversed <= 100'b0;
 
        end else begin
            
            for (int i = 0;
 i < 100;
 i = i + 1) begin
                reversed[i] = in[99 - i];
 
            end
        end
    end

    
    assign out = reversed;

endmodule
