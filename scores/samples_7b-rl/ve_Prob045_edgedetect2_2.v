
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge,
    output [7:0] out
);
    reg [7:0] prev_edge;
    wire [7:0] posedge_edge = anyedge & ~prev_edge;
    reg [7:0] delayed_edge;
    
    always @(posedge clk) begin
        prev_edge <= anyedge;
        delayed_edge <= posedge_edge;
    end
    
    assign out = delayed_edge;
endmodule
