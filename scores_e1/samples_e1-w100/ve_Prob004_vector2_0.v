
module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    
    reg [31:0] reversed;

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            reversed <= 32'b0;
        end else begin
            
            for (int i = 0;
 i < 4;
 i++) begin
                reversed = reversed << 8;
                reversed = reversed | in[31-i];
            end
        end
    end

    
    assign out = reversed;

endmodule
