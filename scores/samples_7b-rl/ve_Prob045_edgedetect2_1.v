
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge,
    output [7:0] out
);

    reg [7:0] prev_in;
    reg [7:0] delay_reg;
    
    
    wire [7:0] edge_rise = (~prev_in) & in;
    wire [7:0] edge_enabled = edge_rise & anyedge;
    
    
    always @(posedge clk) begin
        prev_in <= in;
        delay_reg <= edge_enabled;
    end
    
    assign out = delay_reg;

endmodule
