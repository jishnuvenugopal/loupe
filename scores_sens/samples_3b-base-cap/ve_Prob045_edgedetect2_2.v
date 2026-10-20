
module TopModule (
    input wire clk,
    input wire [7:0] in,
    input wire anyedge,
    output reg [7:0] out
);

    
    reg [7:0] current_state;
    reg [7:0] next_state;

    
    reg [7:0] edge_0_to_1;
    edge_0_to_1 = current_state ^ next_state;

    
    reg [7:0] edge_1_to_0;
    edge_1_to_0 = ~current_state ^ next_state;

    
    reg [7:0] edge_detected;
    edge_detected = edge_0_to_1 | edge_1_to_0;

    
    always @(posedge clk) begin
        
        current_state <= in;

        
        next_state <= in;

        
        edge_detected <= edge_0_to_1 | edge_1_to_0;

        
        out <= edge_detected & anyedge;
    end

endmodule
