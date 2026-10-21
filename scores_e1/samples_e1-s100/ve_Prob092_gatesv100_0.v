
module TopModule (
    input wire [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            out_both <= 100'b0;
            out_any <= 100'b0;
            out_different <= 100'b0;
        end else begin
            out_both[99] <= 0;
 
            out_any[0] <= 0;
  

            for (genvar i = 0;
 i < 99;
 i++) begin
                out_both[i] <= in[i] & in[i + 1];
                out_any[i] <= in[i] | in[i + 1];
                out_different[i] <= in[i] != in[i + 1];
            end
        end
    end

endmodule
