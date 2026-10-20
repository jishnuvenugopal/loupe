
module TopModule (
    input  wire clk,
    input  wire [7:0] in,
    output reg  [7:0] pedge
);

    reg [7:0] pedge_reg;

    always @(posedge clk) begin
        
        if (in != pedge_reg) begin
            pedge_reg <= in;
            pedge     <= 8'b11111111;
 
        end else begin
            pedge_reg <= in;
            pedge     <= 8'b00000000;
 
        end
    end

endmodule
