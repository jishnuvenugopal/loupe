
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge,
    output reg [7:0] out
);

reg [7:0] state;

always @(posedge clk) begin
    state <= in;
  

    out <= out & ~anyedge;
  

    for (int i = 0;
 i < 8;
 i++) begin
        if (state[i] == 0 && in[i] == 1) begin
            out[i] <= 1;
  
        end
    end
end

endmodule
